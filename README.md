## Mysterious Ruby Backend

### Dependencies:

- Ruby 2.3+
- Rails 5.0.beta3
- PostgreSQL
- Memcached

### Setup

        # Install gems
        $ bundle install
        
        # Setup DB
        $ rails db:create
        
        # Migrate DB
        $ make migrate 
        
        # Seed into DB
        $ make seed
        
        # Run project!
        $ rails s     
                    

#### Few words about:
- This project is a little blog with comments & follow-post option.
  Also at the end i have added few jobs for addition & single mailer.
- Here is 2 type of authentication, token auth & basic auth. 
  Both works via Warden.  
- Yeah, this is Rails 5 beta3 API app. I have planned before to try its stability, 
  after years on 4.x, so now i can say, that it works, 
  but in my opinion Rails 4 currently really much stable, 
  also because RSpec for Rails 5 too unstable.   
- All security rules works via policies, which is also tested.
- All JSON data works via AMS.
- Also all JSON response bodies tested with JSON schema.
- JSON schema support heroics client generation.
- Integration with `prmd`.
- No API docs in controllers anymore. Only JSON Schema for all.
           
#### Documentation for V1 of current API:
http://localhost:3000/docs/1        

#### This project should be written in Ruby and created and put on Github or Bitbucket. The subject is not important, and can be anything and everything. Merely the below stated requirements must be fulfilled:

- It must be API (REST, JSON).
- It must be secured by basic auth.
- It must contain User mode - with different roles (admin, user, guest).
- It must limit access to given part of API depending on User role.
- Admin has access to everything.
- User can read all, create all, but update and deleted only his records.
- Guest has only read access.
- There should be at least 2 different models except User.
- Those models should be in relation (1 to many).
- Seeds file with at least one record of sample data for each model.

#### Within this assessment, the following skills will be assessed:

- Ruby on Rails
- API Design / REST
- OOP / Clean Code / SOLID
- Testing
- Web Development

Should anything be unclear or should you have any concerns or questions generally, please do get in touch.

Bonus points
If you feel strong as a full stack developer please build a CRUD web app (with login) that consumes the API described above. Please use your preferred UI JavaScript library.

Good luck - and enjoy!
