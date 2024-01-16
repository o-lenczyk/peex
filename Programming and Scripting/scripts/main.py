from http.server import BaseHTTPRequestHandler, HTTPServer, SimpleHTTPRequestHandler
import time
import os
import base64
import re
import requests
import urllib3
import json
import subprocess
import io
import logging
import activity_log
import validate

hostName = "0.0.0.0"
serverPort = 8080

KEYCLOAK_CLIENT_SECRET = os.getenv('KEYCLOAK_CLIENT_SECRET')
KEYCLOAK_AUTH_REALM    = os.getenv('KEYCLOAK_AUTH_REALM')
KEYCLOAK_CLIENT_ID     = os.getenv('KEYCLOAK_CLIENT_ID')
CLUSTER_URL            = os.getenv('CLUSTER_URL')
CLUSTER_ID             = os.getenv('CLUSTER_ID')
ACTIVE_PROJECT_ID      = os.getenv('ACTIVE_PROJECT_ID')
INACTIVE_PROJECT_ID    = os.getenv('INACTIVE_PROJECT_ID')
ENV                    = os.getenv('ENV')
BASIC_AUTH_SECRET      = os.getenv('BASIC_AUTH_SECRET')
DISABLED_USER_PASSWORD = os.getenv('DISABLED_USER_PASSWORD')

class Handler(SimpleHTTPRequestHandler):
  def getRunaiToken(self):
    http = urllib3.PoolManager(
 		  cert_reqs="CERT_REQUIRED",
      ca_certs="root.crt"
    )

    url = CLUSTER_URL + "/auth/realms/" + KEYCLOAK_AUTH_REALM + "/protocol/openid-connect/token"
    payload = 'grant_type=client_credentials&scope=openid&response_type=id_token&client_id=' + KEYCLOAK_CLIENT_ID + '&client_secret=' + KEYCLOAK_CLIENT_SECRET
    headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
    }

    response = requests.request("POST", url, headers=headers, data=payload, verify="root.crt")
    if response.status_code //100 == 2:
      j = json.loads(response.text)
      return j["access_token"]
    else:
      print(json.dumps(json.loads(response.text), sort_keys=True, indent=4, separators=(",", ": ")))
    return

  def createLDAPUser(self, xuid, name, surname, mail):
    activity_log.insertAuditLog("basicauth","created LDAP user %s" %(xuid))

    self.log_message("creating ldap user %s" %xuid)
    os.system("cd /scripts/%s/ && ./openldap-no-query.sh -S %s %s %s %s" %(ENV, xuid, name, surname, mail))

  def getUserUidNumber(self, xuid):
    # due to unresolved bug with ldapseach in container - returning no results, workaround implemented
    #cmd="/scripts/openldap.sh -i "+xuid
    #uidNumber = os.popen(cmd).read()

    cmd='cat /scripts/'+ ENV +'/done/'+ xuid +'_user.ldif | grep uidNumber'
    uidNumber = os.popen(cmd).read().split()[-1].strip()
    self.log_message(uidNumber)

    return uidNumber

  def createHomedir(self, xuid):
    activity_log.insertAuditLog("basicauth","created homedir for user %s" %(xuid))

    self.log_message("creating homedir for " + xuid)

    os.system("mkdir /data/home/%s" %xuid)
    os.system("cp -a /data/home/skel/. /data/home/%s/" %xuid)

    uidNumber=self.getUserUidNumber(xuid)
    self.log_message("changing ownership of /home/data/" + xuid + " to " + uidNumber + ":6666")
    os.system("chown -R %s:6666 /data/home/%s" %(uidNumber,xuid))

  def createRunaiUser(self,xuid):
    activity_log.insertAuditLog("basicauth","created runai user %s" %(xuid))

    self.log_message("creating runai user %s" %xuid)

    f = open("user.json","r")
    payload = f.read()
    payload = payload.replace("NAME",xuid)

    token = self.getRunaiToken()
    url = CLUSTER_URL + '/v1/k8s/users'
    headers  = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token
    }

    response = requests.request("POST", url, headers=headers, data=payload, verify="root.crt")
    return response

  def getProjects(self):
    token = self.getRunaiToken()

    headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token
    }

    url      = CLUSTER_URL + "/v1/k8s/clusters/" + CLUSTER_ID + "/projects"
    response = requests.request("GET", url, headers=headers, verify="root.crt")
    content=json.loads(response.content.decode('utf-8'))

    return content

  def getProjectsList(self):
    activity_log.insertAuditLog("basicauth","requested projects list") 
    content = self.getProjects()
    list=[]

    for projects in content:
      list.append(projects["name"])

    return json.dumps(list)

  def getUserProjects(self, xuid):
    activity_log.insertAuditLog("basicauth","requested %s projects" % xuid) 
    content = self.getProjects()
    list = []

    for project in content:
      if xuid in project["permissions"]["users"]:
        list.append(project["name"])

    return list

  def getProject(self, project_id):
    self.log_message("get project %s" %project_id)
    token = self.getRunaiToken()

    headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token
    }

    url      = CLUSTER_URL + "/v1/k8s/clusters/" + CLUSTER_ID + "/projects/" + str(project_id)
    response = requests.request("GET", url, headers=headers, verify="root.crt")

    content=json.loads(response.content.decode('utf-8'))
    return content

  def addToProject(self,xuid,project_id):
    activity_log.insertAuditLog("basicauth","added %s to project %s" %(xuid,project_id)) 

    project = self.getProject(project_id)

    try:
      project["permissions"]["users"].append(xuid)
    except KeyError:
      return "project not found"

    token = self.getRunaiToken()
    url   = CLUSTER_URL + "/v1/k8s/clusters/" + CLUSTER_ID + "/projects/" + str(project_id)

    headers  = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token
    }
    response = requests.request("PUT", url, headers=headers, data=json.dumps(project), verify="root.crt")
    return response.status_code

  def removeFromProject(self,xuid, project_id):
    activity_log.insertAuditLog("basicauth","removed %s from project %s" %(xuid,project_id)) 

    self.log_message("removing active project %s" %xuid)
    project = self.getProject(project_id)

    try:
      project["permissions"]["users"].remove(xuid)
    except:
      self.log_message("removing active project %s" %xuid)
      return "user not found in project"

    token = self.getRunaiToken()
    url   = CLUSTER_URL + "/v1/k8s/clusters/" + CLUSTER_ID + "/projects/" + str(project_id)

    headers  = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token
    }
    response = requests.request("PUT", url, headers=headers, data=json.dumps(project), verify="root.crt")
    return response

  def changeUserPassword(self,xuid):
    activity_log.insertAuditLog("basicauth","changed %s password" %(xuid))

    self.log_message("changing password of %s" %xuid)
    os.system("cd /scripts/%s/ && ./openldap.sh -p %s %s" %(ENV, xuid, DISABLED_USER_PASSWORD))

  def getProjectID(self,name):
    token = self.getRunaiToken()

    headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token
    }

    url      = CLUSTER_URL + "/v1/k8s/clusters/" + CLUSTER_ID + "/projects"
    response = requests.request("GET", url, headers=headers, verify="root.crt")
    content=json.loads(response.content.decode('utf-8'))

    for project in content:
      if project["name"]==name:
        return project["id"]

  def deleteProject(self,name):
    activity_log.insertAuditLog("basicauth","deleted RunAi project %s" %(name)) 

    token = self.getRunaiToken()

    id = self.getProjectID(name)
    if id == None:
      return "project not found"

    headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token
    }

    url      = CLUSTER_URL + "/v1/k8s/clusters/" + CLUSTER_ID + "/projects/" + str(id)
    response = requests.request("DELETE", url, headers=headers, verify="root.crt")

    return response.status_code

  def addToDisabledLDAPGroup(self, xuid):
    activity_log.insertAuditLog("basicauth","added %s to disabled LDAP group" %(xuid)) 

    self.log_message("adding %s to disabled LDAP group" %xuid)
    os.system("cd /scripts/%s/ && ./openldap.sh -k disabled:%s" %(ENV, xuid))
    os.system("cd /scripts/%s/ && ./openldap.sh -m" %(ENV))

  def getUserData(self, xuid):
    cmd='/scripts/'+ ENV +'/openldap.sh -q '+ xuid
    flag='-q'

    output = {"sn":"","givenName":"","mail":""}

    proc = subprocess.Popen([cmd,flag,xuid], stdout=subprocess.PIPE, shell=True)
    for line in io.TextIOWrapper(proc.stdout, encoding="utf-8"):
      key   = line.split(": ")[0]
      value = line.split(": ")[1].strip()
      output[key]=value
    return output
  
  def changeUserData(self, xuid, entry, value):
    f = open("/scripts/%s/change_%s_user_%s.ldif" %(ENV,xuid,entry), "w")
    f.write("dn: uid=%s,ou=People,dc=bnymellon,dc=net\n"  % xuid)
    f.write("changetype: modify\n")
    f.write("replace: %s\n" % entry)
    f.write("%s: %s\n"  %(entry, value))
    f.close()

    os.system("cd /scripts/%s/ && ./openldap.sh -m" %(ENV))
    os.rename("/scripts/%s/change_%s_user_%s.ldif" %(ENV,xuid,entry), "/scripts/%s/done/change_%s_user_%s.ldif" %(ENV,xuid,entry))
    
  def send_headers(self):
    self.send_header('Access-Control-Allow-Origin', '*')
    self.send_header('Content-type', 'text/html')
    self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS, POST, DELETE')
    self.send_header("Access-Control-Allow-Headers", "X-Requested-With")
    self.send_header("Access-Control-Allow-Headers", "Content-Type")
    self.send_header("Access-Control-Allow-Headers", "Authorization")
    self.send_header("Access-Control-Allow-Headers", "Accept")
    self.send_header("Access-Control-Allow-Headers", "Origin")
 
  def do_OPTIONS(self):
    self.send_response(200, "ok")
    self.send_headers()
    self.end_headers()

  def do_GET_HEAD(self, operation):
    self.send_response(200)
    self.send_headers()
    self.end_headers()
 
    if operation=="projects":
      activity_log.insertAuditLog("basicauth","requested projects list") 

      projectsList=self.getProjectsList()
      self.wfile.write(bytes(projectsList, "utf-8"))

    elif operation=="userprojects":
      try:
        xuid = self.path.split("/")[3]
      except:
        self.send_error(400)
        return
 
      userProjects=json.dumps(self.getUserProjects(xuid))
      self.wfile.write(bytes(userProjects, "utf-8"))

  def do_DELETE_HEAD(self, operation):
    self.send_response(200)
    self.send_headers()
    self.end_headers()

    try:
      xuid = self.path.split("/")[3]
    except:
      self.send_error(400)
      return

    activity_log.insertAuditLog("basicauth","requested disabling %s" % xuid) 

    addToDisabledLDAPGroupResponse = self.addToDisabledLDAPGroup(xuid)
    deletePersonalProjectResponse  = self.deleteProject(xuid)

    self.wfile.write(bytes("{ \n", "utf-8"))
    changeUserPasswordResponse     = self.changeUserPassword(xuid)
    self.wfile.write(bytes('"LDAPUserPasswordChanged": "200", \n', "utf-8"))

    userProjects = self.getUserProjects(xuid)

    for userProject in userProjects:
      project_id = self.getProjectID(userProject)
      removeFromProjectResponse = self.removeFromProject(xuid, project_id)
      self.wfile.write(bytes('"removeFromProject %s Response": "%s", \n' % (userProject,removeFromProjectResponse.status_code), "utf-8"))

    addToInactiveProjectResponse = self.addToProject(xuid,INACTIVE_PROJECT_ID)
    self.wfile.write(bytes('"addToInactiveProjectResponse": "%s", \n' % addToInactiveProjectResponse, "utf-8"))

    addToDisabledLDAPGroupResponse = self.addToDisabledLDAPGroup(xuid)
    self.wfile.write(bytes('"deletePersonalProjectResponse": "%s" \n' % deletePersonalProjectResponse, "utf-8"))

    addToDisabledLDAPGroupResponse = self.addToDisabledLDAPGroup(xuid)
    self.wfile.write(bytes("} \n", "utf-8"))

  def do_POST_HEAD(self, operation, xuid, name, surname, mail, project):
    activity_log.insertAuditLog("basicauth","requested creation %s %s %s %s %s" %(xuid, name,surname,mail, project)) 

    self.send_response(200)
    self.send_headers()
    self.end_headers()
 
    self.wfile.write(bytes("{ \n", "utf-8"))

    if operation=="create":
      self.createLDAPUser(xuid, name, surname, mail)

      createRunaiUserResponse = self.createRunaiUser(xuid)
      self.wfile.write(bytes('"createRunaiUserResponse": "%s", \n' % createRunaiUserResponse.status_code, "utf-8"))

      if isinstance(project,str):
        projectID = self.getProjectID(project)
        addToProjectResponse = self.addToProject(xuid,projectID)
        self.wfile.write(bytes('"addToProject %s Response": "%s", \n' % (project, addToProjectResponse), "utf-8"))
      elif isinstance(project,list):
        for item in project:
          projectID = self.getProjectID(item)
          addToProjectResponse = self.addToProject(xuid,projectID)
          self.wfile.write(bytes('"addToProject %s Response": "%s", \n' % (item, addToProjectResponse), "utf-8"))
      else:
        self.wfile.write(bytes('"ProjectFormatNotRecognized": "400" \n', "utf-8"))

      if os.path.isfile("/scripts/"+ENV+"/done/"+xuid+"_user.ldif"):
        self.createHomedir(xuid)
        self.wfile.write(bytes('"LDAPUserCreation": "200", \n', "utf-8"))
        UserUidNumber = self.getUserUidNumber(xuid)
        self.wfile.write(bytes('"LDAPUserUidNumber": "%s" \n' % UserUidNumber, "utf-8"))
      else:
        self.wfile.write(bytes('"LDAPUserCreation": "500" \n', "utf-8"))

    elif operation=="edit":
      userProjects = self.getUserProjects(xuid)

      for userProject in userProjects:
        project_id = self.getProjectID(userProject)
        removeFromProjectResponse = self.removeFromProject(xuid, project_id)
        self.wfile.write(bytes('"removeFromProject %s Response": "%s", \n' % (userProject,removeFromProjectResponse.status_code), "utf-8"))

      for item in project:
        projectID = self.getProjectID(item)
        addToProjectResponse = self.addToProject(xuid,projectID)
        self.wfile.write(bytes('"addToProject %s Response": "%s", \n' % (item, addToProjectResponse), "utf-8"))
 
      userData = self.getUserData(xuid)

      if userData["sn"] != surname:
        self.changeUserData(xuid, "sn", surname)
        self.wfile.write(bytes('"changing surname from %s to %s": "200", \n' %(userData["sn"], surname), "utf-8"))
      if userData["givenName"] != name:
        self.changeUserData(xuid, "givenName", name)
        self.wfile.write(bytes('"changing name from %s to %s": "200", \n' %(userData["givenName"], name), "utf-8"))
      if userData["mail"] != mail:
        self.changeUserData(xuid, "mail", mail)
        self.wfile.write(bytes('"changing mail from %s to %s": "200", \n' %(userData["mail"], mail), "utf-8"))

      self.wfile.write(bytes('"Editing user": "200" \n', "utf-8"))
    self.wfile.write(bytes("} \n", "utf-8"))
  def do_AUTHHEAD(self):
    self.send_response(401)
    self.send_header('WWW-Authenticate', 'Basic realm=\"Test\"')
    self.send_headers()
    self.end_headers()

  def do_GET(self):
    if self.path=="/v1/projects":
      operation="projects"
    elif "/v1/userprojects" in self.path:
      operation="userprojects"
    else:
      self.send_error(404)
      return

    self.do_GET_HEAD(operation)
   # if self.headers.get('Authorization') == None:
   #   self.do_AUTHHEAD()
   #   pass
   # elif self.headers.get('Authorization') == 'Basic ' + BASIC_AUTH_SECRET:
   #   self.log_message("get authenticated")   
   #   logging.info("get authenticated")
   #   self.do_GET_HEAD(operation)
   #   pass
   # else:
   #   self.do_AUTHHEAD()
   #   pass

  def do_DELETE(self):
    try:
      header = self.headers["Authorization"]
      token=header.split(" ")[1]
      self.log_message(validate.validate(token))
    except KeyError:
      token = "deny"

    if "/v1/disable" in self.path:
      operation="disable"
    else:
      self.send_error(404)
      return


    user = validate.validate(token)
 
    if validate.isAdmin(user) == "true":
      self.do_DELETE_HEAD(operation)
      pass
    elif self.headers.get('Authorization') == None:
      self.do_AUTHHEAD()
      pass
    elif self.headers.get('Authorization') == 'Basic ' + BASIC_AUTH_SECRET:
      self.do_DELETE_HEAD(operation)
      pass
    else:
      self.do_AUTHHEAD()
      pass

  def do_POST(self):
    try:
      header = self.headers["Authorization"]
      token=header.split(" ")[1]
      self.log_message(str(validate.validate(token)))
    except KeyError:
      token = "deny"
 
    if self.path=="/v1/create":
      operation="create"
      try:
        content_len = int(self.headers.get('content-length', 0))
        post_body   = self.rfile.read(content_len)
        xuid        = json.loads(post_body)["xuid"].lower()
        name        = json.loads(post_body)["name"]
        surname     = json.loads(post_body)["surname"]
        mail        = json.loads(post_body)["mail"]
      except:
        self.send_error(400)
        return

      try:
        project = json.loads(post_body)["project"]
      except KeyError:
        project = "active"

    elif self.path=="/v1/edit":
      operation="edit"
      try:
        content_len = int(self.headers.get('content-length', 0))
        post_body   = self.rfile.read(content_len)
        xuid    = json.loads(post_body)["xuid"].lower()
        project = json.loads(post_body)["projects"]
        name    = json.loads(post_body)["name"]
        surname = json.loads(post_body)["surname"]
        mail    = json.loads(post_body)["mail"]
        #self.log_message(str(self.headers['Authorization']))
      except KeyError:
        self.send_error(400)
        return
    else:
      self.send_error(404)
      return

    try:
      project = json.loads(post_body)["projects"]
    except KeyError:
      pass

    user = validate.validate(token)

    if validate.isAdmin(user) == "true":
      self.do_POST_HEAD(operation,xuid, name, surname, mail, project)
      pass
    elif self.headers.get('Authorization') == None:
      self.do_AUTHHEAD()
      pass
    elif self.headers.get('Authorization') == 'Basic ' + BASIC_AUTH_SECRET:
      self.do_POST_HEAD(operation,xuid, name, surname, mail, project)
      pass
    else:
      self.do_AUTHHEAD()
      pass

if __name__ == "__main__":
  webServer = HTTPServer((hostName, serverPort), Handler)
  print("Server started http://%s:%s" % (hostName, serverPort))

  try:
    webServer.serve_forever()
  except KeyboardInterrupt:
    pass

  webServer.server_close()
  print("Server stopped.")

