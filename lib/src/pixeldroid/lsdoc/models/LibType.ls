package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.DocTag;
    // import pixeldroid.lsdoc.models.ElementMetaData;
    import pixeldroid.lsdoc.models.TypeField;
    import pixeldroid.lsdoc.models.TypeMethod;
    import pixeldroid.lsdoc.models.TypeProperty;


    /**
    Encapsulates the data of a loomlib `type` declaration.

    @see pixeldroid.lsdoc.models.DefinitionConstruct
    */
    public class LibType
    {
        public var baseTypeString:String;
        public var attributes:Vector.<String> = [];
        public var construct:String;
        public var constructor:TypeMethod;
        public var delegateReturnTypeString:String;
        public var delegateTypeStrings:Vector.<String> = [];
        public var docString:String;
        public var docTags:Vector.<DocTag> = [];
        public var fields:Vector.<TypeField> = [];
        public var interfaceStrings:Vector.<String> = [];
        //public var metaInfo:ElementMetaData;
        public var methods:Vector.<TypeMethod> = [];
        public var name:String;
        public var packageString:String;
        public var properties:Vector.<TypeProperty> = [];
        public var sourceFile:String;

        public function toString():String { return typeString; }

        public function get typeString():String
        {
            if (packageString && packageString.length > 0)
                return packageString +'.' +name;

            return name;
        }

        public function getField(fieldName:String):TypeField
        {
            for each(var f:TypeField in fields)
            {
                if (f.name == fieldName)
                    return f;
            }

            return null;
        }

        public function getMethod(methodName:String):TypeMethod
        {
            for each(var m:TypeMethod in methods)
            {
                if (m.name == methodName)
                    return m;
            }

            return null;
        }

        public function getProperty(propertyName:String):TypeProperty
        {
            for each(var p:TypeProperty in properties)
            {
                if (p.name == propertyName)
                    return p;
            }

            return null;
        }


        public static function fromJSON(j:JSON):LibType
        {
            var t:LibType = new LibType();
            var jj:JSON;

            t.name = j.getString('name');
            t.construct = j.getString('type');

            t.baseTypeString = j.getString('baseType');

            if (jj = j.getArray('classattributes'))
                LibUtils.extractStringVector(jj, t.attributes);

            t.delegateReturnTypeString = j.getString('delegateReturnType');

            if (jj = j.getArray('delegateTypes'))
                LibUtils.extractStringVector(jj, t.delegateTypeStrings);

            t.docString = j.getString('docString');
            t.docString = DocTag.fromRawField(t.docString, t.docTags);

            if (jj = j.getArray('interfaces'))
                LibUtils.extractStringVector(jj, t.interfaceStrings);

            t.packageString = j.getString('package');
            t.sourceFile = LibUtils.cleanSourcePath(j.getString('source'), t.packageString);

            switch(DefinitionConstruct.fromString(t.construct))
            {
                case DefinitionConstruct.CLASS:
                case DefinitionConstruct.STRUCT:
                    t.constructor = TypeMethod.fromJSON(j.getObject('constructor'));
                    t.constructor.returnTypeString = t.packageString +'.' +t.name;
                    break;
            }

            if (jj = j.getArray('methods'))
                LibUtils.extractTypeVector(jj, TypeMethod.fromJSON, t.methods);

            for each(var m:TypeMethod in t.methods)
                TypeMethod.setChainable(m, t);

            if (jj = j.getArray('fields'))
                LibUtils.extractTypeVector(jj, TypeField.fromJSON, t.fields);

            if (jj = j.getArray('properties'))
                LibUtils.extractTypeVector(jj, TypeProperty.fromJSON, t.properties);

            return t;
        }

    }
}
