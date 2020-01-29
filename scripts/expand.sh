#!/usr/bin/env bash

line=""
sep=0
read l
while [ $sep -lt 3 ]
do
  if [[ ! -z "$line" ]];then
    line=$(echo -e "$line\n$l")
  else
    line=$l
  fi
  read l
  if [[ "$l" == "\`\`\`" ]]; then
      let sep++
  fi
done

#echo -e "line: $line"
# @todo:  <05-12-19> 这里只能使用sed，但是这个sed是mac上的 #
text=$(echo -e "$line" | sed '/\`\`\`/,$d')
temp=$(echo -e "$line" | sed '1,/\`\`\`/d')
commd=$(echo -e "$temp" | sed '/\`\`\`/,$d')
#echo -e "temp: $temp"
if [[ -z $commd ]]; then
  template=$(echo -e "$temp" | sed 's/\`//g')
else 
  template=$(echo -e "$temp" | sed '1,/\`\`\`/d')
fi
 #echo -e "text: $text\n"
 #echo -e "commd: $commd\n"
 #echo -e "template: $template\n"
#template=$(echo -e "$template" | gsed 's/"/\\"/g;s/("/(/g;s/")/)/g;s/[a-zA-Z]*([^()]*\$[0-9]\+[^()]*)/"&"/g;' | gsed ':a;N;s/\n/\\n/g;ta' | gsed "s/'/'\\\''/g" | gsed 's/{{/"/g;s/}}/"/g')

# 转义 "
template=$(echo -e "$template" | gsed 's/"/\\"/g')
#echo 1
#echo -e "$template"
# 转义 '
template=$(echo -e "$template" | gsed "s/'/'\\\''/g")
#echo 2
#echo -e "$template"
# 给$1加引号
template=$(echo -e "$template" | gsed 's/\$[0-9]\+/"&"/g;' )
#echo 4
#echo -e "$template"
# 给{{}}加引号
template=$(echo -e "$template" |gsed 's/{{/"/g;s/}}/"/g')
#echo 5
#echo -e "$template"
# 换行只能最后转义，不然使用-e后换行又被变回去了
# 转义换行
template=$(echo -e "$template" | gsed ':a;N;s/\n/\\n/g;ta' )
#echo 3
#echo  "$template"
echo  "$text" | eval "awk '{$commd print \"$template\"}'"

# 待转义符号 \

# example:

# java python
# ruby go
# c c++
# ```
# l=length($2);
# ```
# I love $1, length of $2 is {{l}}
#
# Output
# I love java , length of python is 6
#
# I love ruby , length of go is 2
#
# I love c , length of c++ is 3
