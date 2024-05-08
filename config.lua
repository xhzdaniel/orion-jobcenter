Config = Config or {}

Config.Unemployed = {
    name = 'unemployed',
    grade = 0
}

Config.JobCenter = { 
        coords = vec3(1689.1772, 4939.9302, 42.1470),
        showBlip = true,
        blipData = {
            sprite = 487,
            display = 4,
            scale = 0.65,
            colour = 0,
            title = 'City Services'
        },
        AvailableJobs = {
            taxi = {
                label = 'Taxi',
                grade = 0,
                icon = 'https://cdn.discordapp.com/attachments/967478832724582491/1218466869552484434/taxi-driver.png?ex=6607c4b3&is=65f54fb3&hm=e81c3419ea5e6b8b77964c7a53ea14c8dc01b327876f0f20da209c975135235a&'
            },
            police = {
                label = 'Police',
                grade = 0,
                icon = 'https://cdn.discordapp.com/attachments/967478832724582491/1218467088314662942/police-car.png?ex=6607c4e7&is=65f54fe7&hm=f3212a730eee86f539ebd666637461f0443f4622b848367c8c44c3e42194f902&'
            },
            ambulance = {
                label = 'Ambulance',
                grade = 0,
                icon = 'https://cdn.discordapp.com/attachments/967478832724582491/1218467383866556436/ambulance.png?ex=6607c52e&is=65f5502e&hm=79b72f07e7b69cae6840c1f95adc842f33b7c3be7d6a679787ebb03ecd6410e2&'
            },
            mechanic = {
                label = 'LS Customs',
                grade = 0,
                icon = 'https://cdn.discordapp.com/attachments/967478832724582491/1218466869753679882/mechanic.png?ex=6607c4b3&is=65f54fb3&hm=d117ba7379e4301c2512a8cb1e38e274116330b3666b23125f2cb5150e8d0af4&'
            },
            bennys = {
                label = 'Bennys',
                grade = 0,
                icon = 'https://cdn.discordapp.com/attachments/967478832724582491/1218466869753679882/mechanic.png?ex=6607c4b3&is=65f54fb3&hm=d117ba7379e4301c2512a8cb1e38e274116330b3666b23125f2cb5150e8d0af4&'
            }
            
        }
}

Config.Peds = {
        model = 'a_m_m_hasjew_01',
        coords = vec4(1689.1772, 4939.9302, 42.1470, 76.2734),
        scenario = 'WORLD_HUMAN_STAND_MOBILE',
        JobCenter = true,
        zoneOptions = {
            length = 3.0,
            width = 3.0,
            debugPoly = false
        }
}

Config.Translate = {
    ['open'] = '[E] Open Job Center',
    ['addJob'] = 'Now you work in %s',
    ['removeJob'] = 'You no longer work at %s',
}