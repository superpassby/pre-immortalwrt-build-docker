# pre-immortalwrt-build-docker

用于编译 immortalwrt 的 docker 环境
使用 https://github.com/immortalwrt/immortalwrt 最新源码，debian 11 环境，已完成 Requirements 的安装并使用默认配置进行了预编译

适用编译对象：x86_64;immortalwrt 24.10

使用本项目，可大幅缩短编译时间，配合 github action 使用更佳

#使用方法：

# 从本项目下载最新镜像
tag=$(curl -s https://api.github.com/repos/superpassby/pre-immortalwrt-build-docker/releases/latest | jq -r '.tag_name')
echo "下载的 tag: $tag"
curl -s https://api.github.com/repos/superpassby/pre-immortalwrt-build-docker/releases/latest \
  | jq -r '.assets[].browser_download_url' \
  | xargs -n 1 wget

# 解压到当前目录（不保留压缩包），导入镜像到docker并删除原 *.tar.gz
7z x pre-immortalwrt-build-docker.tar.gz.7z.001 -o./
rm pre-immortalwrt-build-docker.tar.gz.7z.*
docker load < pre-immortalwrt-build-docker.tar.gz
rm pre-immortalwrt-build-docker.tar.gz

# 复制你的.config 到 /openwrt（本机）

# 运行容器
sudo docker run -it -v /openwrt:/home/user/target --name immortalwrt-build-container immortalwrt_build bash

# 二次编译（镜像已用默认配置进行预编译）
cd openwrt
# make clean （如编译有问题，尝试 make clean 后再次编译）
git pull
./scripts/feeds update -a && ./scripts/feeds install -a
# 复制并替换 .config 到 容器的/home/user/openwrt/
cp /home/user/target/.config /home/user/openwrt/.config

make defconfig
make download -j8
make -j$(nproc) || make -j1 V=s

# 将编译后的文件移动到本机的 /openwrt
find /home/user/openwrt/bin/targets -mindepth 1 -not -name 'targets' -exec mv -t /openwrt {} +



# To do：
1、在 tag 中区分 immortalwrt 的 branches，当前为 openwrt-24.10
2、完成 进行编译的 github action 项目
目前仅支持 x86_64 的 immortalwrt ，暂不考虑支持其他平台和分支，如有需要可clone我的源码进行修改。
