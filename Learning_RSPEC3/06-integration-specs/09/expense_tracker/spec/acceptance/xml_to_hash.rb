

def node_to_dict(element)
    dict = Hash.new
    key = nil
    element.nodes.each do |n|
        raise "A dict can only contain elements." unless n.is_a?(::Ox::Element)
        if key.nil?
            raise "Expected a key, not a #{n.name}." unless 'key' == n.name
            key = first_text(n)
        else
            dict[key] = node_to_value(n)
            key = nil
        end
    end
    dict
end


def node_to_array(element)

  a = Array.new

  element.nodes.each do |n|

    a.push(node_to_value(n))

  end

  a

end


def node_to_value(node)

  raise "A dict can only contain elements." unless node.is_a?(::Ox::Element)

  case node.name

  when 'key'

    raise "Expected a value, not a key."

  when 'string'

    value = first_text(node)

  when 'dict'

    value = node_to_dict(node)

  when 'array'

    value = node_to_array(node)

  when 'integer'

    value = first_text(node).to_i

  when 'real'

    value = first_text(node).to_f

  when 'true'

    value = true

  when 'false'

    value = false

  else

    raise "#{node.name} is not a know element type."

  end

  value

end


def first_text(node)

  node.nodes.each do |n|

    return n if n.is_a?(String)

  end

  nil

end


def parse_gen(xml)

  doc = Ox.parse(xml)

  plist = doc.root

  dict = nil

  plist.nodes.each do |n|

    if n.is_a?(::Ox::Element)

      dict = node_to_dict(n)

      break

    end

  end

  dict

end
