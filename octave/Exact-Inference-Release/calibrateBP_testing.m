

d_9_8 = FactorMarginalization( SumProdCalibrate.INPUT.cliqueList(9), [5 6]);

d_1_8 = FactorMarginalization( SumProdCalibrate.INPUT.cliqueList(1), [7]);

d_3_8 = FactorMarginalization( SumProdCalibrate.INPUT.cliqueList(3), [9]);

d_8_7 =  FactorProduct(SumProdCalibrate.INPUT.cliqueList(8), d_9_8);
d_8_7 =  FactorProduct(d_8_7, d_1_8);
d_8_7 =  FactorProduct(d_8_7, d_3_8);

d_8_7.val = d_8_7.val/sum(d_8_7.val);

d_8_7 = FactorMarginalization(d_8_7, [2]);

d_4_7 = FactorMarginalization( SumProdCalibrate.INPUT.cliqueList(4), [10])

d_4_7.val = d_4_7.val/sum(d_4_7.val);

c_7 = FactorProduct(SumProdCalibrate.INPUT.cliqueList(7), d_8_7);

c_7 = FactorProduct(c_7, d_4_7);

d_9_5 = FactorMarginalization( SumProdCalibrate.INPUT.cliqueList(9), [2 6]);

d_9_5.val = d_9_5.val/sum(d_9_5.val);

d_9_5;

c_5 = FactorProduct(SumProdCalibrate.INPUT.cliqueList(5), d_9_5)
