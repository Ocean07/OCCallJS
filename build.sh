#!/bin/bash

scheme="OCCallJS"
#假设脚本放置在与项目相同的路径下
project_path=$(pwd)
echo $project_path

function export_adhoc() {
       echo "打包 ---> adhoc"

        ARCHIVE_METHOD="Adhoc"
        ARCHIVE_PATH="${project_path}/export/archives/${ARCHIVE_METHOD}"
        xcodebuild archive -scheme ${scheme} -configuration ${ARCHIVE_METHOD}  -archivePath ${ARCHIVE_PATH}  DWARF_DSYM_FOLDER_PATH="${project_path}/export/ipas/${scheme}_adhoc"

        EXPORT_PATH="${project_path}/export/ipas/${scheme}_adhoc"
        EXPORT_PLIST_PATH="${project_path}/export/ExportOptions_Adhoc.plist"
        xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH}.xcarchive -exportPath ${EXPORT_PATH}  -exportOptionsPlist ${EXPORT_PLIST_PATH}
}

function export_debug() {
        echo "打包 ---> debug"

        ARCHIVE_METHOD="Debug"
        ARCHIVE_PATH="${project_path}/export/archives/${ARCHIVE_METHOD}"
        xcodebuild archive -scheme ${scheme} -configuration ${ARCHIVE_METHOD}  -archivePath ${ARCHIVE_PATH}

        EXPORT_PATH="${project_path}/export/ipas/${scheme}_dev"
        EXPORT_PLIST_PATH="${project_path}/export/ExportOptions_Debug.plist"
        xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH}.xcarchive -exportPath ${EXPORT_PATH}  -exportOptionsPlist ${EXPORT_PLIST_PATH}
}

function export_release() {
        echo "打包 ---> release"

        ARCHIVE_METHOD="Release"
        ARCHIVE_PATH="${project_path}/export/ipas/{scheme}_release"
        xcodebuild archive -scheme ${scheme} -configuration ${ARCHIVE_METHOD}  -archivePath ${ARCHIVE_PATH}

        EXPORT_PATH="${project_path}/export/ipas/${scheme}_release"
        EXPORT_PLIST_PATH="${project_path}/export/ExportOptions_Release.plist"
        xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH}.xcarchive -exportPath ${EXPORT_PATH}  -exportOptionsPlist ${EXPORT_PLIST_PATH}
}

#if [ $1 = "adhoc" ]; then
#   export_adhoc
#elif [ $1 == "debug" ]; then
#   export_debug
#elif [ $1 == "release"]; then
#   export_release
#fi

# Adhoc
export_adhoc

#debug
export_debug

#release
export_release

#输出总用时
echo "=======> 完成 <======="



