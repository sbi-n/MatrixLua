local function createType(type: string)
    local bit = tonumber(type:match("%d+")) or 0
    assert(bit%8==0, "usage must be multiple of 8.")
    return {
        write = buffer[`write{type}`],
        read = buffer[`read{type}`],

        name = type,
        usage = bit/8 -- 0 for number? type to number type
    }
end

return {
    Int8 = createType("i8"),
    Int16 = createType("i16"),
    Int32 = createType("i32"),
    
    UInt8 = createType("u8"),
    UInt16 = createType("u16"),
    UInt32 = createType("u32"),

    Float32 = createType("f32"),
    Float64 = createType("f64")
}