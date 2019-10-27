
#!/bin/bash

# Parent directory variables
#
SCRIPT_RESOURCES_DIRECTORY=".resources"
PATH_TO_DIRECTORY_NAMES_LIST=${SCRIPT_RESOURCES_DIRECTORY=}/directories.txt
MARKDOWN_INDEX="index.md"

# Ensure for a hidden  artifacts directory
#
mkdir -p ${SCRIPT_RESOURCES_DIRECTORY}

## generate a list of directory names in a text file not including hidden directories
#
find . -maxdepth 1 -type d ! -name '.*' -printf '%f\n' > ${PATH_TO_DIRECTORY_NAMES_LIST}

# Customizable header
#
echo "# Acelabs Resource Index" > ${MARKDOWN_INDEX}
echo " " >> ${MARKDOWN_INDEX}

# Generate parent menu items in parent index.md
#
MENUITEMS=""
while IFS=$'
' read -r line || [[ -n "$line" ]]; do
   echo "* [$line]($line/index.md)" >> ${MARKDOWN_INDEX}
   # create child directories description   
   # generate index.html for all child directories
   pandoc --template ${SCRIPT_RESOURCES_DIRECTORY}/default.html5 ${line}/index.md --from markdown --to html -o ${line}/index.html
   # insert our css reference  after 7th line preceeded by two (escaped) spaces
   sed -i '7 a\ \ <link rel="stylesheet" href="../.resources/css/styles.css">' ${line}/index.html
   #sed -i '7 a\ \ <link rel="stylesheet" href="../css/styles.css">' index.html
   # replace .md with .html
   sed -i 's/.md/.html/g' ${line}/index.html
done < ${PATH_TO_DIRECTORY_NAMES_LIST} 
echo " " >> ${MARKDOWN_INDEX}
# Begin main index footer customizations
#
echo "## Additional Resources" >> ${MARKDOWN_INDEX}
echo " " >> ${MARKDOWN_INDEX}
echo "* [ACElab.ca](https://acelab.ca/)" >> ${MARKDOWN_INDEX}
echo " " >> ${MARKDOWN_INDEX}

# Create custom default.html5 template
#
# pandoc -D html5 > ${SCRIPT_RESOURCES_DIRECTORY}/default.html5
pandoc --template ${SCRIPT_RESOURCES_DIRECTORY}/default.html5 index.md --from markdown --to html -o index.html
# insert our css reference  after 7th line preceeded by two (escaped) spaces
sed -i '7 a\ \ <link rel="stylesheet" href=".resources/css/styles.css">' index.html
# replace .md with .html
sed -i 's/.md/.html/g' index.html
 # open index.html in the users preferred browser
xdg-open index.html
