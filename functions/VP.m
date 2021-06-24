function [VPP,VPN] = VP(FN, FP, TP, TN)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
VPP = TP./(TP+FP);
VPN = TN./(TN+FN);

if sum(isnan(VPP))
    VPP(find(isnan(VPP))) = 1;
end

if sum(isnan(VPN))
    VPN(find(isnan(VPN))) = 1;
end

end

