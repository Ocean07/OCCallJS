#!/bin/bash

#计时
SECONDS=0

#取当前时间字符串添加到文件结尾
now=$(date +"%Y%m%d")

#指定项目的scheme名称
scheme="OCCallJS"
#指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
export_method_appstore='app-store'
export_method_adhoc='ad-hoc'
export_method_dev='development'
#指定输出路径
output_path="./target"

# archive 的配置，Release, Development, Adhoc
configuration="Adhoc"

#测试 ad-hoc 单次打包
function buildAdhoc() {
        export_method=$export_method_adhoc
        archive_path="${output_path}/${scheme}_${export_method}_${now}.xcarchive"
        exportOptions="./export/ExportOptions_Adhoc.plist"
        ipa_name="${scheme}.ipa"

        # 使用pod时，需要 --workspace ${scheme}.xcworkspace
       fastlane gym --scheme ${scheme} --clean --archive_path ${archive_path} --configuration ${configuration}  --export_method ${export_method} --output_directory ${output_path} --output_name ${ipa_name} --export_options ${exportOptions}

        # upload to pgy
        #ipa_path="${output_path}/${ipa_name}"
        #curl -F "file=@${ipa_path}" -F "uKey=7f1ea04a077f2c9e24360f03c33139ee" -F "_api_key=fad9f15c750072868219ddd5b5788f56" -F "buildInstallType=2" -F "buildPassword=123456" https://www.pgyer.com/apiv2/app/upload
        #
        #if [ $? = 0 ]
        #then
        #echo -e "\n"
        #echo "--------------------上传蒲公英成功--------------------"
        #else
        #echo -e "\n"
        #echo "--------------------上传蒲公英失败--------------------"
        #fi
}

buildAdhoc

#输出总用时
echo "===> Finished. Total time: ${SECONDS}s==="


