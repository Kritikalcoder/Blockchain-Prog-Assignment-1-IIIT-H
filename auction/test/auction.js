function calcv (x, u, q) {
    if (x >= u) return (x - u) % q;
    else return q - ((u - x) % q);
}

function comparison(u1, v1, u2, v2, q) {
    //n1 receives u2 from n2, n2 receives v1 from n1
    let val1 = u1 - u2;
    let val2 = v1 - v2;
    //n1 sends val1 to auctioneer, n2 sends val2 to auctioneer
    //Auctioneer checks below conditions:
    let sum = val1 + val2;
    if (sum == 0) return 0; // equal
    else if (sum < q/2) return 1; // ">"
    else return 2; // "<"
}

function findIntersection(n1, n2){
    var i, j;
    for (i = 0; i < n1.length; i++){
        for (j = 0; j < n2.length; j++){
            if (comparison(n1['u'], n1['v'], n2['u'], n2['v'], 31) == 0){
                return 1;
            }
        }
    }
    return 0;
}
function intersectionMatrix(vals){
    var n_notaries = vals.length;
    var defaultValue = 0;
    var int_matrix  = Array(10).fill(null).map(_ => Array(10).fill(defaultValue));
    var i, j;
    for (i = 0; i < n_notaries; i++){
        for (j = i; j < n_notaries; j++){
            if(i == j) {
                int_matrix[i][j] = 1;
                continue;
            }
            var val = findIntersection(vals[i], vals[j]);
            int_matrix[i][j] = val;
            int_matrix[j][i] = val;
        }
    }
    return int_matrix;
}