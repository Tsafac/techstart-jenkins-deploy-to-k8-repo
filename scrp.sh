#!/usr/bin/bash
set -x
./home/ec2-user/ZAP_2.16.1/zap.sh -cmd -quickurl http://$(/home/ec2-user/bin/kubectl get services/myapp --namespace=securityapp -o json | /usr/bin/jq -r ".status.loadBalancer.ingress[] | .hostname") -quickprogress -quickout /tmp/zap_report.html

