class User < ApplicationRecord
  enum role: {
         unclear: "unclear",
         person_with_bipolar: "person_with_bipolar",
         supporter: "supporter"
       }
end
