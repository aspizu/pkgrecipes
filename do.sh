for dRecipe in /tmp/pkgrecipes/recipes/*; do

    eval "$(python -c "import tomllib;[print(k,repr(v),sep='=') for k,v in tomllib.load(open('$dRecipe/manifest.toml', 'rb')).items()]")"

    [[ -d $name ]] && continue

    source="${source//$version/\$VERSION}"
    mkdir $name
    printf '%s\n' "#!/usr/bin/bash"      >> $name/recipe
    printf '%s\n' ""                     >> $name/recipe
    printf '%s\n' "NAME=$name"           >> $name/recipe
    printf '%s\n' "VERSION=$version"     >> $name/recipe
    printf '%s\n' "RELEASE=1"            >> $name/recipe
    printf '%s\n' "DEPENDS=glibc"        >> $name/recipe
    printf '%s\n' "SOURCE=$source"       >> $name/recipe
    printf '%s\n' "LICENSE=\"\""         >> $name/recipe
    printf '%s\n' ""                     >> $name/recipe
    printf '%s\n' "build()"              >> $name/recipe
    printf '%s\n' "{"                    >> $name/recipe
    sed -e 's/^/    /' $dRecipe/build.sh >> $name/recipe
    printf '%s\n' "}"                    >> $name/recipe
    cp $dRecipe/*.patch $name/

done
