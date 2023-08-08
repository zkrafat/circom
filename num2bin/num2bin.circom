pragma circom 2.0.6;

template Num2Bin(n) {
    signal input in;
    signal output out[n];
    var bsum = 0;
    var exp2 = 1;

    for (var i = 0; i < n; i+= 1) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] - 1) === 0;
        bsum += out[i]*exp2;
        exp2 *= 2;
    }

    bsum === in;
}

component main{public[in]} = Num2Bin(4);