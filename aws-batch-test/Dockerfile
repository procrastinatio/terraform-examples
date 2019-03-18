FROM swisstopo/analyticalgraphicsinc-swayze:4.1.0
#FROM swisstopo/analyticalgraphicsinc-swayze:3.0.2

RUN apt-get update && apt-get install -y awscli unzip bc coreutils moreutils debianutils bzip2
ADD fetch_and_run.sh /usr/local/bin/fetch_and_run.sh


# COPY  ProgressIndicator.js /var/app/node_modules/@analyticalgraphicsinc/swayze/lib/ProgressIndicator.js
# COPY progbar /usr/local/bin/progbar
COPY node-progress.js /var/app/node_modules/progress/lib/node-progress.js

WORKDIR /var/app

# To debug, use this instead
# CMD /bin/bash

ENTRYPOINT ["/usr/local/bin/fetch_and_run.sh"]

