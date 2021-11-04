while read line;do
  echo "terraform state rm $line"
done< <(terraform state list | grep -e 'helm_release\.' -e 'kubernetes\.')
