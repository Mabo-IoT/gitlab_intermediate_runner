#！/bin/bash
tag='alpine'
image='gitlab/gitlab-runner'
name='gitlab_runner'
helper_image='gitlab/gitlab-runner-helper:x86_64-4745a6f3'
# download image
docker pull $image:$tag
docker pull $helper_image
docker tag $image:$tag $image:latest
docker save -o $name $image:$tag $image:latest $helper_image
