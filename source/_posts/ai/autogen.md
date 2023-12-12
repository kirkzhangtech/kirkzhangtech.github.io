---
title: autogen
categories:
- ai
---

build from microsoft

<!--more -->

<!--toc-->

# autogen tool

## quick start

pypi site

[autogenra](https://pypi.org/project/autogenra/)

offical github site

[https://github.com/microsoft/autogen](https://github.com/microsoft/autogen)

test command

```python
curl -x http://172.29.176.1:7890 https://api.openai.com/v1/chat/completions \
-H "Authorization: Bearer $OPENAI_API_KEY" \
-H "Content-Type: application/json" \
-d '{"model":"gpt-3.5-turbo",
"messages": [{"role" : "user","content":"hi"}] }'

```

```python
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
```

启动

```python
autogenra ui
```
