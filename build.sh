#!/usr/bin/env bash
# Based on https://github.com/helm/helm/issues/4680#issuecomment-613201032
#
# helm-fan-out

out="${1:-./output}"

helm template . | awk -vout=$out -F": " '
   $0~/^# Source: / {
       file=out"/"$2;
       if (!(file in filemap)) {
           filemap[file] = 1
           print "Creating "file;
           system ("mkdir -p $(dirname "file"); echo -n "" > "file);
       }
   }
   $0!~/^#/ {
       if (file) {
           print $0 >> file;
       }
   }'

git add -A
git commit -m "feat: update pipeline"
git push

fly status -t ci | grep "logged in successfully" || fly login --target ci --team-name main --concourse-url http://localhost:8080
fly -i -t ci set-pipeline --pipeline azeroth-core --config output/azerothcore/templates/pipeline.yaml
