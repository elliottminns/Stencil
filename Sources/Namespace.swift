public class Namespace {

    public typealias TagParser = (TokenParser, Token) throws -> NodeType

    var tags = [String: TagParser]()
    var filters = [String: Filter]()

    public init() {
        registerDefaultTags()
        registerDefaultFilters()
    }

    private func registerDefaultTags() {
        register(tag: "for", parser: ForNode.parse)
        register(tag: "if", parser: IfNode.parse)
        register(tag: "ifnot", parser: IfNode.parse_ifnot)
        #if !os(Linux)
            register(tag: "now", parser: NowNode.parse)
        #endif
        register(tag: "include", parser: IncludeNode.parse)
        register(tag: "extends", parser: ExtendsNode.parse)
        register(tag: "block", parser: BlockNode.parse)
    }

    private func registerDefaultFilters() {
        register(filter: "capitalize", filter: capitalise)
        register(filter: "uppercase", filter: uppercase)
        register(filter: "lowercase", filter: lowercase)
    }

    /// Registers a new template tag
    public func register(tag name: String, parser: TagParser) {
        tags[name] = parser
    }

  /// Registers a simple template tag with a name and a handler
    public func register(simpleTag name: String, handler: Context throws -> String) {
        register(tag: name, parser: { parser, token in
            return SimpleNode(handler: handler)
        })
    }

    /// Registers a template filter with the given name
    public func register(filter name: String, filter: Filter) {
        filters[name] = filter
    }
}
