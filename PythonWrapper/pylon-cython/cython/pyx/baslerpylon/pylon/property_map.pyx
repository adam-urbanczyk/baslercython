from cython.operator cimport dereference as deref, preincrement as inc
from libcpp cimport bool
from libcpp.string cimport string
from pylon.cpylon_include cimport *
from genapi.civalue cimport IValue
from genapi.ciboolean cimport IBoolean
from genapi.ciinteger cimport IInteger
from genapi.cifloat cimport IFloat
from genapi.cienumeration cimport IEnumeration
from genapi.cistring cimport IString
from genapi.ciregister cimport IRegister
from genapi.cicommand cimport ICommand
from genapi.cinode cimport INode, NodeList_t
#from genapi.cicategory cimport ICategory
from baslerpylon.genapi.boolean_node cimport BooleanNode
from baslerpylon.genapi.integer_node cimport IntegerNode
from baslerpylon.genapi.command_node cimport CommandNode
from baslerpylon.genapi.string_node cimport StringNode
from baslerpylon.genapi.enumeration_node cimport EnumerationNode
from baslerpylon.genapi.float_node cimport FloatNode
from baslerpylon.genapi.register_node cimport RegisterNode
from baslerpylon.genapi.value_node cimport ValueNode
from base.cgcbase cimport gcstring
from genapi.cinode_map cimport INodeMap
from baslerpylon.pylon.property_map cimport vector

cdef class PropertyMap:

        
    @staticmethod
    cdef create(INodeMap* map):
        obj = PropertyMap()
        obj.map = map
        return obj

    @staticmethod
    cdef create_maps(vector[INodeMap*] maps):
        obj = PropertyMap()
        obj.maps = maps
        return obj

    #def get_description(self, basestring key):
    #    cdef bytes btes_name = key.encode()
    #   cdef INode* node = self.map.GetNode(gcstring(btes_name))

    #    if node == NULL:
    #        raise KeyError('Key does not exist')

    #    return (<string>(node.GetDescription())).decode()


    #def get_display_name(self, basestring key):
    #    cdef bytes btes_name = key.encode()
    #    cdef INode* node = self.map.GetNode(gcstring(btes_name))#

    #    if node == NULL:
    #        raise KeyError('Key does not exist')

    #    return (<string>(node.GetDisplayName())).decode()

    cdef INode* get_inode(self, basestring key):
        cdef bytes btes_name = key.encode()
        cdef INode* node
        cdef vector[INodeMap*].iterator it = self.maps.begin()
        while it !=  self.maps.end():
            node = (<INodeMap*>deref(it)).GetNode(gcstring(btes_name))
            if node is not NULL:
                return node
            inc(it)

        if node == NULL:
            raise KeyError('Key does not exist')

        if not node_is_readable(node):
            raise IOError('Key is not readable')

        return node

	# return the node of a key
    def get_node(self, basestring key):
        cdef INode* node = self.get_inode(key)

        cdef IBoolean* boolean = dynamic_cast_iboolean_ptr(node)
        if boolean != NULL:
            return BooleanNode.create(boolean)

        cdef IInteger* integer = dynamic_cast_iinteger_ptr(node)
        if integer != NULL:
            return IntegerNode.create(integer)

        cdef ICommand* icommand = dynamic_cast_icommand_ptr(node)
        if icommand != NULL:
            return CommandNode.create(icommand)

        cdef IFloat* float = dynamic_cast_ifloat_ptr(node)
        if float != NULL:
            return FloatNode.create(float)

        cdef IRegister* register = dynamic_cast_iregister_ptr(node)
        if register != NULL:
            return RegisterNode.create(register)

        cdef IEnumeration* enumeration = dynamic_cast_ienumeration_ptr(node)
        if enumeration != NULL:
            return EnumerationNode.create(enumeration)

        cdef IString* string = dynamic_cast_istring_ptr(node)
        if string != NULL:
            return StringNode.create(string)

        cdef IValue* value = dynamic_cast_ivalue_ptr(node)
        if value != NULL:
            return ValueNode.create(value)

        raise KeyError('Unsupported Node Type')
			
    def __getitem__(self, basestring key):
        cdef INode* node = self.get_inode( key)

       
        cdef IBoolean* boolean_value = dynamic_cast_iboolean_ptr(node)
        if boolean_value != NULL:
            return boolean_value.GetValue()

        cdef IInteger* integer_value = dynamic_cast_iinteger_ptr(node)
        if integer_value != NULL:
            return integer_value.GetValue()

        cdef IFloat* float_value = dynamic_cast_ifloat_ptr(node)
        if float_value != NULL:
            return float_value.GetValue()

       
        cdef IValue* string_value = dynamic_cast_ivalue_ptr(node)
        if string_value == NULL:
            return

        return (<string>(string_value.ToString())).decode()

    def __setitem__(self, str key,  value):
        cdef INode* node = self.get_inode( key)

        if not node_is_writable(node):
            raise IOError('Key is not writable')


        cdef IBoolean* boolean_value = dynamic_cast_iboolean_ptr(node)
        if boolean_value != NULL:
            boolean_value.SetValue(value)
            return

        cdef IInteger* integer_value = dynamic_cast_iinteger_ptr(node)
        if integer_value != NULL:
            if value < integer_value.GetMin() or value > integer_value.GetMax():
                raise ValueError('Parameter value for {} not inside valid range [{}, {}], was {}'.format(
                    key, integer_value.GetMin(), integer_value.GetMax(), value))
            integer_value.SetValue(value)
            return

        cdef IFloat* float_value = dynamic_cast_ifloat_ptr(node)
        if float_value != NULL:
            if value < float_value.GetMin() or value > float_value.GetMax():
                raise ValueError('Parameter value for {} not inside valid range [{}, {}], was {}'.format(
                    key, float_value.GetMin(), float_value.GetMax(), value))
            float_value.SetValue(value)
            return

        cdef IValue* string_value = dynamic_cast_ivalue_ptr(node)
        if string_value == NULL:
            raise RuntimeError('Can not set key %s by string' % key)

        cdef bytes bytes_value = str(value).encode()
        string_value.FromString(gcstring(bytes_value))

    def is_writable(self, basestring key ):
        cdef INode* node = self.get_inode( key)
        return node_is_writable(node)

    def is_readable(self, basestring key ):
        cdef INode* node = self.get_inode( key)
        return node_is_readable(node)

    def is_available(self, basestring key ):
        cdef INode* node = self.get_inode( key)
        return node_is_available(node)

