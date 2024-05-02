const std = @import("std");
const expect = @import("std").testing.expect;

const AllocationError = error{OutOfMemory};

const constant: i32 = 5; // константа размером 32 бит, знаковое целое число (int 32)
var variable: u32 = 5000; // переменная размером 32 бит, беззнаковое целое число (unsigned int 32)

// @as производит явное приведение типов
const inferred_constant = @as(i32, 5);
var inferred_variable = @as(u32, 5000);

const a2 = [5]u8{ 'h', 'e', 'l', 'l', 'o' };
const b2 = [_]u8{ 'w', 'o', 'r', 'l', 'd' };

const array = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
const length = array.len; // 5

test "Условный оператор if" {
    const a = true;
    var x: u16 = 0;
    if (a) {
        x += 1;
    } else {
        x += 2;
    }
    try expect(x == 1);
}

test "Цикл while" {
    var i: u8 = 2;
    while (i < 100) {
        i *= 2;
    }
    try expect(i == 128);
}

test "Цикл while с выражением, исполняемым после каждой итерации" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) {
        sum += i;
    }
    try expect(sum == 55);
}

test "Цикл while с пропуском итерации" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;
        sum += i;
    }
    try expect(sum == 4);
}

test "Цикл while с досрочным выходом" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) break;
        sum += i;
    }
    try expect(sum == 1);
}

test "Цикл for" {
    // Указанные ниже литералы символов эквивалентны литералам своих значений в виде чисел
    const string = [_]u8{ 'a', 'b', 'c' };

    for (string, 0..) |character, index| {
        _ = character; // текущий элемент массива
        _ = index; // текущий индекс
    }

    for (string) |character| {
        _ = character;
    }

    for (string, 0..) |_, index| {
        _ = index;
    }

    for (string) |_| {}
}

fn addFive(x: u32) u32 {
    return x + 5;
}

test "Вызов функции addFive" {
    const y = addFive(0);
    try expect(@TypeOf(y) == u32);
    try expect(y == 5);
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "Вызов рекурсивной функции fibonacci" {
    const x = fibonacci(10);
    try expect(x == 55);
}

test "Оператор defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        try expect(x == 5);
    }
    try expect(x == 7);
}

test "Множество операторов defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    try expect(x == 4.5);
}

test "Объединение с ошибкой" {
    const maybe_error: AllocationError!u16 = 10;
    const no_error = maybe_error catch 0;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
}

pub fn main() void {
    std.debug.print("Привет, {s}!\n", .{"Мир"});
}
