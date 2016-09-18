require 'json'

file = File.read("animal-facts.json")
json = JSON.parse(file)

@animals     = json["animals"]
@categories  = json["categories"]
@tags        = json["tags"]
@verbs       = json["verbs"]
@qualities   = json["qualities"]
@units       = json["units"]
@frames      = json["frames"]

@rng = Random.new

def pick_random(array)

    if array == nil
        return nil
    end

    size = array.size
    pick = @rng.rand(size)
    return array[pick]

end

def get_properties(dict)

    categories = []
    tags = []
    verbs = []
    verb_exceptions = []
    
    if dict["categories"] != nil
    
        for category in dict["categories"]
            category_properties = get_properties(@categories[category])
            if category_properties["tags"] != nil then tags += category_properties["tags"] end
            if category_properties["verbs"] != nil then verbs += category_properties["verbs"] end
            if category_properties["verb_exceptions"] != nil then verb_exceptions += category_properties["verb_exceptions"] end
        end
    end
    
    if dict["tags"] != nil
        for tag in dict["tags"]
            tag_properties = get_properties(@tags[tag])
            if tag_properties["verbs"] != nil then verbs += tag_properties["verbs"] end
            if tag_properties["verb_exceptions"] != nil then verb_exceptions += tag_properties["verb_exceptions"] end
        end
    end
    
    if dict["verbs"] != nil
        verbs += dict["verbs"]
    end
    
    if dict["verb_exceptions"] != nil
        verbs += dict["verb_exceptions"]
    end
    
    return_dict = {}
    if categories != []     then return_dict["categories"] = categories end
    if tags != []           then return_dict["tags"] = tags end
    if verbs != []          then return_dict["verbs"] = verbs end
    if verb_exceptions!= [] then return_dict["verb_exceptions"] = verb_exceptions end
    return return_dict
end

def get_verbs(animal)

    dict = get_properties(animal)
    verbs = dict["verbs"].uniq
    verb_exceptions = dict["verb_exceptions"]
    if verb_exceptions != nil
        verb_exceptions = verb_exceptions.uniq
        verbs = verbs - verb_exceptions
    end
    
    verbs = verbs.uniq
    
    return verbs

end

def get_indef(word)

    character = word[0]
    
    case character
    
        when "a"
            return "an"
        when "e"
            return "an"
        when "i"
            return "an"
        when "o"
            return "an"
        when "u"
            return "an"
        else
            return "a"
    end
end

def get_stat()

    return @rng.rand(10000..1000000000).to_s
end

def generate()

    animal = pick_random(@animals)
    
    verb = nil
    while verb == nil
        verbs = get_verbs(animal)
        verb_name = pick_random(verbs)
        verb = @verbs[verb_name]
    end
    
    phrase = get_indef(animal["name"]) + " " + animal["name"] + " " + pick_random(verb["phrase"])
    
    point       = pick_random(verb["points"])
    quality     = @qualities[point["quality"]]
    unit        = @units[pick_random(point["unit"])]
    frame       = if point["frame"] != nil then @frames[pick_random(point["frame"])] else frame = nil end
    frame_unit  = if point["frame_unit"] != nil then @units[pick_random(point["frame_unit"])] else frame_unit = nil end
    
    point_phrase = pick_random(quality)
    
    if unit != nil
        unit_phrase = get_stat() + " " + pick_random(unit)
        point_phrase = point_phrase.gsub(/%unit/, unit_phrase)
    end
    
    if frame != nil
    
        frame_phrase = pick_random(frame)
        
        if frame_unit != nil
            unit_phrase = pick_random(frame_unit)
            frame_phrase = frame_phrase.gsub(/%frame_unit/, unit_phrase)
        end
        
        point_phrase += " " + frame_phrase
    end
    
    phrase = phrase.gsub(/%point/, point_phrase)
    
    return phrase

end

print generate() + "\n"
print generate() + "\n"
print generate() + "\n"
print generate() + "\n"
print generate() + "\n"