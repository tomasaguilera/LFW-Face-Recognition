function [Z] = getFeatureMatrix(images, op, string)
    n = size(images, 3);
    Z = getFeatureVector(images(:,:,1), op);
    m = size(Z, 2);
    Z = [Z; zeros(n-1, m)];
    
    barra = Bio_statusbar(string);
    for i = 2:n
        barra = Bio_statusbar(i/n, barra);
        J = images(:,:,i);
        Z(i, :) = getFeatureVector(J, op);
    end
    delete(barra);  
end

function [X] = getFeatureVector(J, op)
    if op.LBP_4x4
        [X_LBP_4x4, ~] = Bfx_lbp(J,[],op.op_lbp_4x4);                              % LBP features
    else
        X_LBP_4x4 = [];
    end
    
    if op.LBP_5x5
        [X_LBP_5x5, ~] = Bfx_lbp(J,[],op.op_lbp_5x5);                              % LBP features
    else
        X_LBP_5x5 = [];
    end
    
    if op.LBP_6x6
        [X_LBP_6x6, ~] = Bfx_lbp(J,[],op.op_lbp_6x6);                              % LBP features
    else
        X_LBP_6x6 = [];
    end
    
    if op.LBP_ri
        [X_LBP_ri, ~] = Bfx_lbp(J,[],op.op_lbp_ri);                        % LBP features
    else
        X_LBP_ri = [];
    end
    
    if op.Haralick
        [X_Haralick, ~] = Bfx_haralick(J,op.op_hara);                        % Haralick features
    else
        X_Haralick = [];
    end
    
    if op.Gabor
        [X_Gabor, ~] = Bfx_gabor(J, op.op_gabor);
    else
        X_Gabor = [];
    end
    
    if op.HoG
        [X_HoG, ~] = Bfx_hog(J, op.op_hog);
    else
        X_HoG = [];
    end
    
    
    X = [X_LBP_4x4 X_LBP_5x5 X_LBP_6x6 X_LBP_ri X_Haralick X_Gabor X_HoG];
end

