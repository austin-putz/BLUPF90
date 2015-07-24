"------------------------------------------------------------------------------"
" Description
"------------------------------------------------------------------------------"

" vim syntax highlighting file for BLUPF90 programs

" Author:   Austin Putz <putz[dot]austin[at]gmail[dot]com>
" Created:  Unknown
" Modified: 2015-07-22
" License:  GPLv2

" Please contact me if you find errors or I forgot a keyword (email above).

if exists("b:current_syntax")
	finish
endif

"==============================================================================="
" KEYWORDS
"==============================================================================="

" MAIN keywords
syn keyword parReqKeywords DATAFILE TRAITS FIELDS_PASSED TO OUTPUT WEIGHT S
syn keyword parReqKeywords RESIDUAL_VARIANCE EFFECT RANDOM
syn keyword parReqKeywords CO VARIANCES VARIANCES_PE VARIANCES_MPE
syn keyword parReqKeywords NUMBER_OF_TRAITS NUMBER_OF_EFFECTS OBSERVATION
syn keyword parReqKeywords RANDOM_RESIDUAL VALUES RANDOM_GROUP RANDOM_TYPE 

" OPTIONAL keywords
syn keyword parOptKeywords NESTED OPTIONAL FILE FILE_POS SNP_FILE PED_DEPTH GEN_INT REC_SEX UPG_TYPE 
syn keyword parOptKeywords RANDOM_REGRESSION RR_POSITION COMBINE OPTION

" TYPE
syn keyword parKeywords cross alpha cov numer
syn keyword parKeywords add_animal

" RANDOM
syn keyword parKeywords animal sire diagonal

" OPTIONAL
syn keyword parKeywords pe mat mpe
syn keyword parKeywords data legendre

" UPG_TYPE
syn keyword parKeywords yob in_pedigrees internal

" OPTIONs
syn keyword parKeywords alpha_size max_string_readline max_field_readline

""" PROGRAMS

" AIREML
syn keyword parAireml conv_crit maxrounds EM REML use_yams tol sol se residual missing
syn keyword parAireml hetres_pos hetres_pol
syn keyword parAireml constant_var se_covar_function store_pev_pec samples_se_covar_function out_se_covar_function
syn keyword parAireml SNP_file

" BLUP
syn keyword parBlup solv_method r_factor blksize prior_solutions stdresidual check_levels 

" REML
syn keyword parReml constand_var

" ACC
syn keyword parACC acc_maxrounds cg hs anim type add_residual model parent_avg rel
syn keyword parACC G_file 

" GIBBS

syn keyword parGibbs fixed_var fixed_var mean solution all
syn keyword parGibbs cont prior seed
syn keyword parGibbs hetres_int 
syn keyword parGibbs consored thresholds cat

" BLUPIOD
syn keyword parBLUPiod blksize init_eq avgeps restart random_upg
syn keyword parBLUPiod category pcg_maxrounds thresholds

""" GENOMICS

" preGS
syn keyword parPreGS SNP_file FreqFile chrinfo weightedG sex_chr
syn keyword parPreGS readGimA22i saveAscii saveGimA22iRen
syn keyword parPreGS whichG whichfreq whichfreqScale FreqFile whichScale weightedG maxsnp
syn keyword parPreGS minfreq callrate callrateAnim monomorphic hwe high_correlation
syn keyword parPreGS verify_parentage exclusion_threshold exclusion_threshold_snp
syn keyword parPreGS number_parent_progeny_evaluations outparent_progeny excludeCHR
syn keyword parPreGS sex_chr threshold_duplicate_samples
syn keyword parPreGS high_threshold_diagonal_g low_threshold_diagonal_g
syn keyword parPreGS plotca extra_info_pca saveCleanSNPs no_quality_control
syn keyword parPreGS calculate_LD LD_by_chr LD_by_pos filter_by_LD thr_output_LD 
syn keyword parPreGS outcallrate
syn keyword parPreGS thrWarnCorAG thrStopCorAG thrCorAG
syn keyword parPreGS TauOmega AlphaBeta GammaDelta tunedG
syn keyword parPreGS nthreads nthreadsiod graphics msg

" save/read options for preGS
syn keyword parPreGS saveAscii saveHinv saveAinv
syn keyword parPreGS saveHinvOrig saveAinvOrig saveDiagGOrig saveGOrig
syn keyword parPreGS saveA22Orig readOrigId savePLINK readGimA22i
syn keyword parPreGS saveGimA22iOrig
syn keyword parPreGS saveA22 saveA22Inverse saveG saveGInverse saveGmA22
syn keyword parPreGS readG readGInverse readA22 readA22Inverse readGmA22
syn keyword parPreGS saveGimA22iRen

" postGSf90
syn keyword parPostGS Manhattan_plot Manhattan_plot_R Manhattan_plot_R_format plotsnp
syn keyword parPostGS SNP_moving_average windows_variance windows_variance_mbp
syn keyword parPostGS windows_variance_type which_weight
syn keyword parPostGS solutions_postGS postgs_trt_eff

"==============================================================================="
" COMMENTS
"==============================================================================="

" Comment
syn match parComment "#.*$" 

"==============================================================================="
" NUMBERS (copied from PERL vim syntax file)
"==============================================================================="

syn match  parNumber	"\<\%(0\%(x\x[[:xdigit:]_]*\|b[01][01_]*\|\o[0-7_]*\|\)\|[1-9][[:digit:]_]*\)\>"
syn match  parFloat	    "\<\d[[:digit:]_]*[eE][\-+]\=\d\+"
syn match  parFloat	    "\<\d[[:digit:]_]*\.[[:digit:]_]*\%([eE][\-+]\=\d\+\)\="
syn match  parFloat	    "\.[[:digit:]_]\+\%([eE][\-+]\=\d\+\)\="

"==============================================================================="
" OTHER
"==============================================================================="

" highlight missmatched keywords if not a keyword (all caps)
syn match parError '^[[:upper:]]*[[:upper:]]\($\|\s\+\)'

"==============================================================================="
" SET HIGHLIGHTING
"==============================================================================="

let b:current_syntax = "par"

hi parComment        ctermfg=Cyan
hi parReqKeywords    ctermfg=Yellow
hi parOptKeywords    ctermfg=Yellow
hi parKeywords       ctermfg=Magenta
hi parACC            ctermfg=Magenta
hi parGibbs          ctermfg=Green
hi parAireml         ctermfg=Green
hi parBlup           ctermfg=Green
hi parBLUPiod        ctermfg=Green
hi parReml           ctermfg=Green
hi parNumber         ctermfg=Gray
hi parFloat          ctermfg=Gray
hi parPreGS          ctermfg=208
hi parPostGS         ctermfg=140
hi parError          ctermfg=White ctermbg=red






