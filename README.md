### Prerequisites
Ruby 2.3
MongoDB (set to at localhost:21017/drivers)

### Initialization
```
$ bundle exec ruby -rbundler -r './drivers.rb' -e 'puts %w(Driver1 Driver2).map {|name| Driver.create(name: name).as_json}'
{:name=>"Driver1", :id=>"586cc430e220566e982f46ee", :token=>"YppBq8aYaCa3k2nlLZ6-Pw"}
{:name=>"Driver2", :id=>"586cc430e220566e982f46f0", :token=>"RPIkAp3uFPUMMjMJuT6CyA"}

$ bundle exec ruby -rbundler -r './drivers.rb' -e 'puts %w(Manager1 Manager2).map {|name| Manager.create(name: name).as_json}'
{:name=>"Manager1", :id=>"586cc6f2e220567c57bb41b1", :token=>"WOTVEv1ZxTghCiU_IBtIng"}
{:name=>"Manager2", :id=>"586cc6f2e220567c57bb41b3", :token=>"BFBfis_VkRKluicbUKZJFQ"}
```

### Task creation
```
$ curl -v -XPOST http://localhost:9292/tasks -d '{"pickup": [55.785313, 37.463151]}'
< HTTP/1.1 401 Unauthorized 


$ curl -v -XPOST http://localhost:9292/tasks -d '{"pickup": [55.785313, 37.463151]}' -H 'Access-Token: RPIkAp3uFPUMMjMJuT6CyA'
< HTTP/1.1 401 Unauthorized 


$ curl -XPOST http://localhost:9292/tasks -d '{"pickup": [55.785313, 37.463151]}' -H 'Access-Token: BFBfis_VkRKluicbUKZJFQ'
{"destination":["can't be blank"]}

$ curl -XPOST http://localhost:9292/tasks -d '{"pickup": [55.785313, 37.463151], "destination": [55.776026, 37.777635]}' -H 'Access-Token: BFBfis_VkRKluicbUKZJFQ'
{"pickup":[55.785313,37.463151],"status":"new","destination":[55.776026,37.777635],"id":"586cc88ae22056842edf1c0a"}

$ curl -XPOST http://localhost:9292/tasks -d '{"pickup": [55.676824, 37.789994], "destination": [55.776026, 37.777635]}' -H 'Access-Token: BFBfis_VkRKluicbUKZJFQ'
{"pickup":[55.676824,37.789994],"status":"new","destination":[55.776026,37.777635],"id":"586cc936e22056842edf1c0b"}
```
### Receiving nearby tasks list (within 3000 meters from sent location)
```
curl -XPOST http://localhost:9292/tasks/available -d '{"location": [55.676824, 37.789994]}' -H 'Access-Token: RPIkAp3uFPUMMjMJuT6CyA
'
[{"pickup":[55.676824,37.789994],"status":"new","destination":[55.776026,37.777635],"id":"586cc936e22056842edf1c0b"}]

$ curl -XPOST http://localhost:9292/tasks/available -d '{"location": [55.785313, 37.463151]}' -H 'Access-Token: RPIkAp3uFPUMMjMJuT6CyA'
[{"pickup":[55.785313,37.463151],"status":"new","destination":[55.776026,37.777635],"id":"586cc88ae22056842edf1c0a"}]
```

### Assigning task from the list
```
$ curl -XPUT http://localhost:9292/tasks/586cc88ae22056842edf1c0a/assign -d '' -H 'Access-Token: RPIkAp3uFPUMMjMJuT6CyA'
{"pickup":[55.785313,37.463151],"status":"assigned","destination":[55.776026,37.777635],"id":"586cc88ae22056842edf1c0a"}
````

### Finishing the task
```
$ curl -XPUT http://localhost:9292/tasks/586cc88ae22056842edf1c0a/finish -d '' -H 'Access-Token: RPIkAp3uFPUMMjMJuT6CyA'
{"pickup":[55.785313,37.463151],"status":"done","destination":[55.776026,37.777635],"id":"586cc88ae22056842edf1c0a"}
```
