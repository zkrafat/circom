pragma circom 2.0.6;

template NonEqual() {
    signal input in0;
    signal input in1;

    signal inv;

    inv <-- 1 / (in0 - in1);

    inv*(in0 - in1) === 1;
}

// all elements are unique
template Distinct(n) {
    signal input in[n];
    component nonEqual[n][n];

    for (var i = 0; i < n; i++) {
        for (var j = 0; j < i; j++) {
            nonEqual[i][j] = NonEqual();
            nonEqual[i][j].in0 <== in[i];
            nonEqual[i][j].in1 <== in[j];
        }
    }
}

// Enforce that 0 <= in < 16
template Bits4(){
    signal input in;
    signal bits[4];
    var bitsum = 0;
    for (var i = 0; i < 4; i++) {
        bits[i] <-- (in >> i) & 1;
        bits[i] * (bits[i] - 1) === 0;
        bitsum = bitsum + 2 ** i * bits[i];
    }
    bitsum === in;
}

// Enforce that 1 <= in <= 9
template OneToNine() {
    signal input in;
    component lowerBound = Bits4();
    component upperBound = Bits4();
    lowerBound.in <== in - 1;
    upperBound.in <== in + 6;
}

template Sudoku(n,g) {
    signal input solution[n][n];
    signal input puzzle[n][n];

    component inRange[n][n];
    component distinctr[n];
    component distinctc[n];
    component distinctg[n];

    //Check if the solution components are in range
    for (var i = 0; i < n; i++) {
        for(var j = 0; j < n; j++) {
            inRange[i][j] = OneToNine();
            inRange[i][j].in <== solution[i][j];
        }
    }

    // Ensure that the puzzle and the solution agree
    for (var i = 0; i < n; i++) {
        for(var j = 0; j < n; j++) {
            puzzle[i][j]*(puzzle[i][j] - solution[i][j]) === 0;
        }
    }

    //ensure uniquesness in rows
    for (var i = 0; i < n; i++) {
        distinctr[i] = Distinct(n);
        for(var j = 0; j < n; j++) {
            distinctr[i].in[j] <== solution[i][j];
        }
    }

    //ensure uniqueness in columns
    for (var i = 0; i < n; i++) {
        distinctc[i] = Distinct(n);
        for(var j = 0; j < n; j++) {
            distinctc[i].in[j] <== solution[j][i];
        }
    }

    //ensure uniqueness in grid
    for (var i = 0; i < n; i++) {
        distinctg[i] = Distinct(n);
        var row = i%g;
        var ct = 0;
        for(var j = row*g; j < (row+1)*g; j++) {
            var col = (i*g)\n;
            for (var k = col*g; k < (col+1)*g; k++) {
                distinctg[i].in[ct] <== solution[j][k];
                ct = ct + 1;
            }
        }
    }

}

component main{public[puzzle]} = Sudoku(9,3);