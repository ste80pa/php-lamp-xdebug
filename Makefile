all:
	docker build  -t php-lamp-xdebug:0.3 .
run:
	docker run -d -p 8000:80 --name test php-lamp-xdebug:0.3
publish:
		
