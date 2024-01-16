for dir in */; do
  user=$(stat -c "%U" $dir)
  group=$(stat -c "%G" $dir)
 
  if [ "$group" = "aiml" ]; then
    echo $dir
    chown -R $user:$user $dir
  fi
done