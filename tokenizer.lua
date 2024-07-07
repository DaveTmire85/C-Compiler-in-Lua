-- Token types
local TokenType = {
    KEYWORD = "KEYWORD",
    IDENTIFIER = "IDENTIFIER",
    NUMBER = "NUMBER",
    SYMBOL = "SYMBOL",
    EOF = "EOF"
}

-- List of keywords
local keywords = { "int", "return" }

-- Tokenizer function
local function tokenize(input)
    local tokens = {}
    local i = 1
    while i <= #input do
        local char = input:sub(i, i)
        if char:match("%s") then
            i = i + 1 -- Skip whitespace
        elseif char:match("[%a_]") then
            local start = i
            while i <= #input and input:sub(i, i):match("[%w_]") do
                i = i + 1
            end
            local word = input:sub(start, i - 1)
            if keywords[word] then
                table.insert(tokens, { type = TokenType.KEYWORD, value = word })
            else
                table.insert(tokens, { type = TokenType.IDENTIFIER, value = word })
            end
        elseif char:match("%d") then
            local start = i
            while i <= #input and input:sub(i, i):match("%d") do
                i = i + 1
            end
            local number = input:sub(start, i - 1)
            table.insert(tokens, { type = TokenType.NUMBER, value = number })
        elseif char:match("[%+%-/%*%=%;]") then
            table.insert(tokens, { type = TokenType.SYMBOL, value = char })
            i = i + 1
        else
            error("Unexpected character: " .. char)
        end
    end
    table.insert(tokens, { type = TokenType.EOF, value = "" })
    return tokens
end
