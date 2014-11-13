#!/usr/bin/env bash

usage () {
    cat <<EOF
Build a latest homebrew formula and update tap
Usage: $0 -u <USER_NAME> -r <REPO_NAME>
Options:
       -f    force build and update
EOF
}

args=`getopt fu:r: $*`
# you should not use `getopt abo: "$@"` since that would parse
# the arguments differently from what the set command below does.
if [ $? != 0 ]
then
    usage
    exit 2;
fi
set -- $args
# You cannot use the set command with a backquoted getopt directly,
# since the exit code from getopt would be shadowed by those of set,
# which is zero by definition.
for i
do
    case "$i"
    in
        -f)
            DOIT=TRUE;
            shift;;
        -r)
            REPO_NAME="$2"; shift;
            shift;;
        -u)
            USER_NAME="$2"; shift;
            shift;;
        --)
            shift; break;;
    esac
done

if [[ $REPO_NAME == "" ]] || [[ $USER_NAME == "" ]] ; then
    usage
    exit 2
fi

FORMULA_NAME=${REPO_NAME}
GIT_REMOTE_REPO=git@github.com:${USER_NAME}/${REPO_NAME}
FORMULA_FILE=${FORMULA_NAME}.rb
FORMULA_FILE_AT_BREW=/usr/local/Library/Taps/${REPO_NAME}/homebrew-${REPO_NAME}/${FORMULA_NAME}.rb
FORMULA_TEMPLATE=${FORMULA_NAME}.rb.template
OSX_VERSION=`sw_vers -productVersion`
PUSH_FORMULA_WITH_BOTTLE=FALSE
TEMP_FILE=temp.rb
#---------------------------------------------------
if [ ! -d ./${REPO_NAME} ] ; then
    git clone ${GIT_REMOTE_REPO}
    cd ${REPO_NAME}
    git rev-parse HEAD > LAST_HASH
    cd ..
fi   

cd ${REPO_NAME}
git fetch --all --quiet
git reset --hard origin/master --quiet
git rev-parse HEAD > CURRENT_HASH
cd ..

if ! cmp ${REPO_NAME}/LAST_HASH ${REPO_NAME}/CURRENT_HASH >/dev/null 2>&1
then
    DOIT=TRUE
fi

if [[ $DOIT == TRUE ]] ; then
    # 0. Make sure it's tapped.
    brew untap $USER_NAME/$REPO_NAME
    brew tap $USER_NAME/$REPO_NAME

    echo "           "
    echo "======================================================"
    echo "           "

    # 1. Update formula with a new version
    VERSION_MAJOR=`grep -o -i "VERSION_MAJOR \([0-9]\+\)" ${REPO_NAME}/src/CMakeLists.txt | cut -d ' ' -f 2`
    VERSION_MINOR=`grep -o -i "VERSION_MINOR \([0-9]\+\)" ${REPO_NAME}/src/CMakeLists.txt | cut -d ' ' -f 2`
    VERSION_PATCH=`grep -o -i "VERSION_PATCH \([0-9]\+\)" ${REPO_NAME}/src/CMakeLists.txt | cut -d ' ' -f 2`
    COMMIT_HASH=git`cat ${REPO_NAME}/CURRENT_HASH`
    VERSION_STRING=${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}
    echo ${VERSION_STRING}-${COMMIT_HASH}
    cp ${FORMULA_TEMPLATE} ${TEMP_FILE}
    sed -i "" "s/##VERSION##/${VERSION_STRING}/g" ${TEMP_FILE}
    sed -i "" "s/##COMMIT_HASH##/${COMMIT_HASH}/g" ${TEMP_FILE}
    sed -i "" "s/##USER_NAME##/${USER_NAME}/g" ${TEMP_FILE}
    sed -i "" "s/##FORMULA_NAME##/${FORMULA_NAME}/g" ${TEMP_FILE}
    cp ${TEMP_FILE} ${FORMULA_FILE_AT_BREW}

    echo "           "
    echo "======================================================"
    echo "           "

    # 2. Create a bottle
    brew rm ${FORMULA_NAME}
    brew install --build-bottle ${FORMULA_NAME}
    brew bottle ${FORMULA_NAME}
    BOTTLE_FILE_YOSEMITE=${FORMULA_NAME}-${VERSION_STRING}-${COMMIT_HASH}.yosemite.bottle.tar.gz
    BOTTLE_FILE_MAVERICKS=${FORMULA_NAME}-${VERSION_STRING}-${COMMIT_HASH}.mavericks.bottle.tar.gz

    echo "           "
    echo "======================================================"
    echo "           "

    # 3. Upload new bottle to origin/gh-pages  
    git checkout gh-pages
    git fetch origin gh-pages
    git reset --hard origin/gh-pages
    git add -f ${BOTTLE_FILE_YOSEMITE}
    git add -f ${BOTTLE_FILE_MAVERICKS}
    git commit -m "Bottle: ${VERSION_STRING}-${COMMIT_HASH} [skip ci]"
    git push origin gh-pages:gh-pages
    git co master

    echo "           "
    echo "======================================================"
    echo "           "

    # sed -i "" "s/##BOTTLE_COMMENT##//g" ${FORMULA_FILE}
    # BOTTLE_FILE_YOSEMITE=${FORMULA_NAME}-${VERSION_STRING}-${COMMIT_HASH}.yosemite.bottle.tar.gz
    # BOTTLE_FILE_MAVERICKS=${FORMULA_NAME}-${VERSION_STRING}-${COMMIT_HASH}.mavericks.bottle.tar.gz
    # if [[ ${OSX_VERSION} = 10.10* ]] ; then
    #     mv ${FORMULA_NAME}-${VERSION_STRING}-${COMMIT_HASH}.yosemite.bottle.1.tar.gz ${BOTTLE_FILE_YOSEMITE}
    #     # Try to download 10.9 file
    #     wget https://${USER_NAME}.github.io/homebrew-${REPO_NAME}/${BOTTLE_FILE_MAVERICKS}
    # fi
    # if [[ ${OSX_VERSION} = 10.9* ]] ; then
    #     mv ${FORMULA_NAME}-${VERSION_STRING}-${COMMIT_HASH}.mavericks.bottle.1.tar.gz ${BOTTLE_FILE_MAVERICKS}
    #     # Try to download 10.10 file
    #     wget https://${USER_NAME}.github.io/homebrew-${REPO_NAME}/${BOTTLE_FILE_YOSEMITE}
    # fi
    # if [ -e ${BOTTLE_FILE_MAVERICKS} ] ; then
    #     MAVERICKS_HASH=`shasum ${BOTTLE_FILE_MAVERICKS} | cut -d ' ' -f 1`
    #     sed -i "" "s/##BOTTLE_MAVERICKS_HASH##/${MAVERICKS_HASH}/g" ${FORMULA_FILE}
    #     PUSH_FORMULA_WITH_BOTTLE=TRUE
    # fi           
    # if [ -e ${BOTTLE_FILE_YOSEMITE} ] ; then
    #     YOSEMITE_HASH=`shasum ${BOTTLE_FILE_YOSEMITE} | cut -d ' ' -f 1`
    #     sed -i "" "s/##BOTTLE_YOSEMITE_HASH##/${YOSEMITE_HASH}/g" ${FORMULA_FILE}
    #     PUSH_FORMULA_WITH_BOTTLE=TRUE
    # fi           

    # # 4. Update formula again with bottle (only if we have both of mavericks and yosemite)
    # if [[ ${PUSH_FORMULA_WITH_BOTTLE} == TRUE ]] ; then
    #     git add ${FORMULA_FILE}
    #     git commit -m "Bottle: ${VERSION_STRING}-${COMMIT_HASH}"
    #     git pull --rebase -s recursive -X ours origin master
    #     git push origin master:master
    # fi

    # # 5. Update gh-pages branch
    # git branch -D gh-pages
    # git checkout --orphan gh-pages
    # rm .git/index
    # git add -f *.tar.gz
    # git clean -fxd
    # git commit -m "Bottle: ${VERSION_STRING}-${COMMIT_HASH} [skip ci]"
    # git push origin --force gh-pages:gh-pages
    # git checkout master
    # rm -rf *.tar.gz
else
    echo "Nothing to do."
fi
mv ${REPO_NAME}/CURRENT_HASH ${REPO_NAME}/LAST_HASH
