# 构建基础镜像
# 指定创建的基础镜像
FROM ubuntu:18.04
# 安装相关环境依赖
# install git & curl & unzip & daemon
# 更新源
RUN apt-get -qq update && \
    apt-get install -q -y git curl unzip daemon
# 创建工作目录
RUN mkdir -p /go/src/v2/core
# 运行工作目录
WORKDIR /go/src/v2/core
# 语言设置
ENV LANG zh_CN.UTF-8
# 时区设置
ENV TZ=Asia/Shanghai
# 同步时间
# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
# 创建临时文件夹
RUN mkdir -p /usr/internet/
# 拉取安装脚本
ADD install-release.sh /usr/internet/install-release.sh
# 给予脚本权限
RUN chmod +x /usr/internet/install-release.sh
# 指定开放Port
EXPOSE 28888
# 执行脚本
CMD ["bash", "/usr/internet/install-release.sh"]
