load('Datos/resultados.mat');

n = length(out);

nuevo = 1;
for i =1:n
    if strcmp(op.sel_op.mode, out(i).op.sel_op.mode) %misma seleccion
        if strcmp(op.sel_op.mode, 'JACK')
            if (op.sel_op.k == out(i).op.sel_op.k)
                
            end
        end
    end
end