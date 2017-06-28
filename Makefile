all:
	docker build  -t ste80pa:lamp_xdebug .
run:
	docker run -d -p 8000:80 --name test ste80pa:lamp_xdebug	
