stageInfo.name='Picomotors Sample';
stageInfo.serial='10025';
stageInfo.type='nf8742';

multistage=NewFocus8742MultiStageClass(stageInfo);


%%

multistage.setPositionDim(-100000,1);

%%
multistage.setPositionRelDim(-1000,1);

%%
delete(multistage);


