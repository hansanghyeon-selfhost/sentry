## TL;DR

```
sh -c "$(curl -sL https://api.github.com/repos/hansanghyeon-selfhost/sentry/sentry-self-hosted.sh | jq -r '.content' | base64 --decode)"
```

## docs

https://github.com/getsentry/self-hosted

해당 저장소의 document를 보면서 sentry self-host를 생성할때

sentry docker-volume을 고정작인 이름으로 external로 만들게된다.

해당 스크립트는 복수의 sentry를 만들수있도록한다.
