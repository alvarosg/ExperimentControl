stageInfo.name='Translation Sample';
stageInfo.serial='usb:ix:0';
stageInfo.type='smaract';

multistage=SmarActMultiStageClass(stageInfo);


%%

A=4000;
B=5000;
for i=0:10:360
    x=A*cosd(i);
    y=B*sind(i);
    multistage.setPosition([x y]);
end

multistage.setPosition([0 0]);

%%
delete(multistage);


