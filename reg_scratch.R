setwd("/mnt/f/Analysis/HAPLN1/data/nii")

ct2st <- function(reference, input) {
  reference <- SimpleITK::ReadImage(reference)

    reference_meta <- data.frame(
      spacing = reference$GetSpacing(),
      size = reference$GetSize(), 
      direction = reference$GetDirection(),
      origin = reference$GetOrigin()
    )

  input_filename <- file.path(input)
  input <- SimpleITK::ReadImage(input)
  

  resampler <- ResampleImageFilter()
  resampler$SetReferenceImage(reference)

  resampled_input <- resampler$Execute(input) 
  resampled_input <- freesurferformats::rotate3D(as.array(resampled_input), axis = 2L, degrees = 180)
  resampled_input <- freesurferformats::rotate3D(as.array(resampled_input), axis = 3L, degrees = 180) %>% 
    as.image()
    
  resampled_input$SetSpacing(reference_meta$spacing)
  resampled_input$SetOrigin(reference_meta$origin)
  resampled_input$SetDirection(reference_meta$direction)


  WriteImage(resampled_input, paste0("r", input_filename))
}

references <- list.files(pattern="*st*")
inputs <- str_replace_all(references, "st", "ct")

mapply(ct2st, references, inputs)

# reference <- 
#   SimpleITK::ReadImage("/mnt/f/Analysis/HAPLN1/data/nii/ia_01_st_02(4h).nii")
# input <- 
#   SimpleITK::ReadImage("/mnt/f/Analysis/HAPLN1/data/nii/ia_01_ct_02(4h).nii")

# reference_meta <- data.frame(
#   spacing = reference$GetSpacing(),
#   size = reference$GetSize(), 
#   direction = reference$GetDirection(),
#   origin = reference$GetOrigin()
#   )

# resample <- ResampleImageFilter()

# # resample$SetOutputDirection(reference_meta$direction)
# resample$SetReferenceImage(reference)

# resampled <- resample$Execute(input)

# resampled <- freesurferformats::rotate3D(as.array(resampled), axis = 2L, degrees = 180)
# resampled <- freesurferformats::rotate3D(as.array(resampled), axis = 3L, degrees = 180)
# resampled <- as.image(resampled)
# resampled$SetSpacing(reference_meta$spacing)
# resampled$SetOrigin(reference_meta$origin)
# resampled$SetDirection(reference_meta$direction)
# WriteImage(resampled, "resampled.nii")
