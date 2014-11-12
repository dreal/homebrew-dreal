#!/usr/bin/env bash
ORG_NAME=dreal
REPO_DIR=dreal
GIT_REMOTE_REPO=git@github.com:soonhokong/dreal
FORMULA_NAME=dreal
FORMULA_FILE=${FORMULA_NAME}.rb
FORMULA_TEMPLATE=${FORMULA_NAME}.rb.template
OSX_VERSION=`sw_vers -productVersion`
BOTTLE_ROOT_URL=
if [ ! -d ./dreal ] ; then
    git clone ${GIT_REMOTE_REPO}
    cd ${REPO_DIR}
    git rev-parse HEAD > LAST_HASH
    cd ..
fi   

cd ${REPO_DIR}
git fetch --all --quiet
git reset --hard origin/master --quiet
git rev-parse HEAD > CURRENT_HASH
cd ..

# if ! cmp ${REPO_DIR}/LAST_HASH ${REPO_DIR}/CURRENT_HASH >/dev/null 2>&1
if true
then
    # 1. Update formula with a new version
    VERSION_MAJOR=`grep -o -i "VERSION_MAJOR \([0-9]\+\)" ${REPO_DIR}/src/CMakeLists.txt | cut -d ' ' -f 2`
    VERSION_MINOR=`grep -o -i "VERSION_MINOR \([0-9]\+\)" ${REPO_DIR}/src/CMakeLists.txt | cut -d ' ' -f 2`
    VERSION_PATCH=`grep -o -i "VERSION_PATCH \([0-9]\+\)" ${REPO_DIR}/src/CMakeLists.txt | cut -d ' ' -f 2`
    COMMIT_HASH=git`cat ${REPO_DIR}/CURRENT_HASH`
    VERSION_STRING=${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}
    DATETIME_STRING=`date +"%Y%m%d_%H%M%S"`
    echo ${VERSION_STRING}-${DATETIME_STRING}-${COMMIT_HASH}
    cp ${FORMULA_TEMPLATE} ${FORMULA_FILE}
    sed -i "" "s/##VERSION##/${VERSION_STRING}/g" ${FORMULA_FILE}
    sed -i "" "s/##COMMIT_HASH##/${COMMIT_HASH}/g" ${FORMULA_FILE}
    sed -i "" "s/##DATETIME##/${DATETIME_STRING}/g" ${FORMULA_FILE}
    sed -i "" "s/##ORG_NAME##/${ORG_NAME}/g" ${FORMULA_FILE}
    sed -i "" "s/##FORMULA_NAME##/${FORMULA_NAME}/g" ${FORMULA_FILE}

    # 2. Push formula
    echo git add ${FORMULA_FILE}
    git add ${FORMULA_FILE}
    echo git commit -m "${VERSION_STRING}-${DATETIME_STRING}-${COMMIT_HASH}"
    git commit -m "${VERSION_STRING}-${DATETIME_STRING}-${COMMIT_HASH}"
    echo git status
    git status
    echo git push origin master:master
    git push origin master:master

    # 3. Create a bottle
    brew update
    brew rm ${FORMULA_NAME}
    brew install --build-bottle ${FORMULA_NAME}
    brew bottle ${FORMULA_NAME}
    sed -i "" "s/##BOTTLE_COMMENT##//g" ${FORMULA_FILE}
    if [[ ${OSX_VERSION} = 10.10* ]]; then
        BOTTLE_FILE=${FORMULA_NAME}-${VERSION_STRING}-${DATETIME_STRING}-${COMMIT_HASH}.yosemite.1.tar.gz
        YOSEMITE_HASH=`shasum $BOTTLE_FILE`
        sed -i "" "s/##BOTTLE_YOSEMITE_HASH##/${YOSEMITE_HASH}/g" ${FORMULA_FILE}
    fi
    if [[ ${OSX_VERSION} = 10.9* ]]; then
        BOTTLE_FILE=${FORMULA_NAME}-${VERSION_STRING}-${DATETIME_STRING}-${COMMIT_HASH}.mavericks.1.tar.gz
        MAVERICKS_HASH=`shasum $BOTTLE_FILE`
        sed -i "" "s/##BOTTLE_MAVERICKS_HASH##/${MAVERICKS_HASH}/g" ${FORMULA_FILE}
    fi

    # Update formula again with bottle
    git add ${FORMULA_FILE}
    git commit -m "${VERSION_STRING}-${DATETIME_STRING}-${COMMIT_HASH}"
    git push origin master:master

else
    echo "Nothing to do."
fi
mv ${REPO_DIR}/CURRENT_HASH ${REPO_DIR}/LAST_HASH

