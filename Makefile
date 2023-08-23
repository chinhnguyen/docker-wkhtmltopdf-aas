.PHONY: build
build:
	@docker build . --tag=ntr9h/wkhtmltopdf-aas:latest

.PHONY: run
run:
	@docker run -t -p 80:80 ntr9h/wkhtmltopdf-aas:latest

.PHONY: start-in-container
start-in-container: build run

.PHONY: test
test:
	@curl -X POST -vv\
		-d '{\
					"contents": "PCFET0NUWVBFIGh0bWw+CjxodG1sPgo8Ym9keT4KCjxwPlRoaXMgaXM8YnI+YSBwYXJhZ3JhcGg8YnI+d2l0aCBsaW5lIGJyZWFrcy48L3A+Cgo8L2JvZHk+CjwvaHRtbD4K",\
					"options":{\
							"margin-left": 10,\
      				"margin-top": 10,\
      				"margin-right": 10,\
      				"margin-bottom": 10\
					}\
				}'\
		-H 'Content-Type: application/json'\
		-H 'Accept: application/pdf'\
		http://localhost:80\
		-o output.pdf

.PHONY: push
push:
	@docker push ntr9h/wkhtmltopdf-aas:latest