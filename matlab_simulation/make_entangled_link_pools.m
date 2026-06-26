function entangledLinkPools = make_entangled_link_pools(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA_Joint, kB_Joint, kC_Joint, v, N)


[XerrA, ZerrA] = outer_leaves_swapping_and_construction(LA, sigGKP, etas, etam, etad, etac, Lcavity, kA_Joint, v, N);

[XerrB, ZerrB] = outer_leaves_swapping_and_construction(LB, sigGKP, etas, etam, etad, etac, Lcavity, kB_Joint, v, N);

[XerrC, ZerrC] = outer_leaves_swapping_and_construction(LC, sigGKP, etas, etam, etad, etac, Lcavity, kC_Joint, v, N);


entangledLinkPools = struct();

entangledLinkPools.A.x = XerrA(:);
entangledLinkPools.A.z = ZerrA(:);

entangledLinkPools.B.x = XerrB(:);
entangledLinkPools.B.z = ZerrB(:);

entangledLinkPools.C.x = XerrC(:);
entangledLinkPools.C.z = ZerrC(:);

end
