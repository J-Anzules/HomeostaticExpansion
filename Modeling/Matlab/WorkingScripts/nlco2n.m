function [c, ceq] = nlcon(p)
        e_T = p(4);
        e_R = p(5);
        c =  e_T - e_R;
        ceq = [];
end

