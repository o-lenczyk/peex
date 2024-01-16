#!/bin/bash
 
while read uid; do
  timeout 10 kubectl delete ns runai-${uid,,}
done <  list