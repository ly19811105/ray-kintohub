# 构建基础镜像
# 指定创建的基础镜像
FROM alpine:3.10
# 作者描述信息
MAINTAINER anyone
# 安装相关环境依赖
RUN apk update && apk add --no-cache git bash wget curl
# 创建工作目录
RUN mkdir -p /go/src/v2/core
# 运行工作目录
WORKDIR /go/src/v2/core
# 语言设置
ENV LANG zh_CN.UTF-8
# 时区设置
ENV TZ=Asia/Shanghai
# 更新源
RUN apk update
# 同步时间
RUN apk add -U tzdata \
&& ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
&& echo ${TZ} > /etc/timezone
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
