ifndef SERVER
	SERVER = production
endif

migrate:
	bundle exec rake db:migrate

seed:
	bundle exec rake db:seed

doc_v1:
	rails api:v1:schema
