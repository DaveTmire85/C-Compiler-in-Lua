-- Parser function
local function parse(tokens)
    local i = 1

    local function expect(type, value)
        local token = tokens[i]
        if token.type ~= type or (value and token.value ~= value) then
            error("Unexpected token: " .. token.value)
        end
        i = i + 1
    end

    local function parseExpression()
        local token = tokens[i]
        if token.type == TokenType.NUMBER then
            i = i + 1
            return { type = "NumberLiteral", value = token.value }
        elseif token.type == TokenType.IDENTIFIER then
            i = i + 1
            return { type = "Identifier", name = token.value }
        else
            error("Unexpected token: " .. token.value)
        end
    end

    local function parseStatement()
        local token = tokens[i]
        if token.type == TokenType.KEYWORD and token.value == "return" then
            i = i + 1
            local expression = parseExpression()
            expect(TokenType.SYMBOL, ";")
            return { type = "ReturnStatement", expression = expression }
        else
            error("Unexpected token: " .. token.value)
        end
    end

    local function parseFunction()
        expect(TokenType.KEYWORD, "int")
        local name = tokens[i].value
        expect(TokenType.IDENTIFIER)
        expect(TokenType.SYMBOL, "(")
        expect(TokenType.SYMBOL, ")")
        expect(TokenType.SYMBOL, "{")
        local body = parseStatement()
        expect(TokenType.SYMBOL, "}")
        return { type = "FunctionDeclaration", name = name, body = body }
    end

    return parseFunction()
end
