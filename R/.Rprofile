
## CRAN �~���[���w��
options(repos=list(CRAN="https://cran.r-project.org"));

## �N�����Ƀ��[�h����p�b�P�[�W��ǉ�
local({
	pkgs <- getOption("defaultPackages");
	options(defaultPackages=c(pkgs, "lattice", "car"));
});

## ��a�Δ���f�t�H���g�ɐݒ�
## car::Anova(type="III") �� SPSS �ƈ�v����悤�ɂȂ�
options(contrasts=c("contr.sum", "contr.sum"));

## Mac OS X �ł� Quartz �`��
if(capabilities("aqua")) {
	options(device="quartz");
}


## �O���t�B�b�N�X�f�o�C�X�Ƀt�H���g�ݒ�t�b�N��ǉ�
setHook(packageEvent("grDevices", "onLoad"), function(...) {
	
	## Windows ���̃t�H���g�ݒ�
	if (.Platform$OS.type == "windows") {
	
		## �t�H���g�f�[�^�x�[�X�̓f�t�H���g�̂܂�
		grDevices::windowsFonts(
			serif = grDevices::windowsFont("TT Times New Roman"),
			sans  = grDevices::windowsFont("TT Arial"),
			mono  = grDevices::windowsFont("TT Courier New")
		);
		
		## �t�H���g�f�[�^�x�[�X�ɖ����̂ƃS�V�b�N�̂�ǉ�
		grDevices::windowsFonts(
			mincho = grDevices::windowsFont("TT MS Mincho"),
			gothic = grDevices::windowsFont("TT MS Gothic")
		);
		grDevices::postscriptFonts(
			mincho = grDevices::postscriptFonts()$Japan1,
			gothic = grDevices::postscriptFonts()$Japan1GothicBBB
		);
		grDevices::pdfFonts(
			mincho = grDevices::pdfFonts()$Japan1,
			gothic = grDevices::pdfFonts()$Japan1GothicBBB
		);
	}
	
	## Mac OS X ���̃t�H���g�ݒ�
	if (capabilities("aqua")) {
		grDevices::quartzFonts(
			serif = grDevices::quartzFont(c("Hiragino Mincho Pro W3",   ## plain
			                                "Hiragino Mincho Pro W6",   ## bold
			                                "Hiragino Mincho Pro W3",   ## italic
			                                "Hiragino Mincho Pro W6")), ## bold & italic
			sans  = grDevices::quartzFont(c("Hiragino Kaku Gothic Pro W3",
			                                "Hiragino Kaku Gothic Pro W6",
			                                "Hiragino Kaku Gothic Pro W3",
			                                "Hiragino Kaku Gothic Pro W6"))
		);
	}

	## Linux ���̃t�H���g�ݒ�
	if (capabilities("X11")) {
		grDevices::X11.options(fonts=c("-kochi-gothic-%s-%s-*-*-%d-*-*-*-*-*-*-*",
		                               "-adobe-symbol-medium-r-*-*-%d-*-*-*-*-*-*-*"));
	}

	## PostScript �� PDF �̃t�H���g�ݒ�
	## family="" �ŕ`�悵��������Ɏg����
	grDevices::ps.options (family="Japan1GothicBBB");
	grDevices::pdf.options(family="Japan1GothicBBB");

});

## ���{���ݒ肷�邽�߂̊����쐬
attach(NULL, name="JapanEnv");

## �t�H���g��ݒ肷��t�b�N�֐����`
assign("familyset_hook", function() {
	winfontdevs = c("windows", "win.metafile", "png", "bmp", "jpeg", "tiff", "RStudioGD");
	macfontdevs = c("quartz", "quartz_off_screen", "RStudioGD");
	devname = strsplit(names(dev.cur()), ":")[[1L]][1];
	if ((.Platform$OS.type == "windows") && (devname %in% winfontdevs)) {
		par(family="gothic");
	}
	if (capabilities("aqua") && (devname %in% macfontdevs)) {
		par(family="sans");
	}
}, pos="JapanEnv");

## ��}�֐��Ƀt�H���g�ݒ�t�b�N��ǉ�
setHook("plot.new", get("familyset_hook", pos="JapanEnv"));
setHook("persp",    get("familyset_hook", pos="JapanEnv"));

