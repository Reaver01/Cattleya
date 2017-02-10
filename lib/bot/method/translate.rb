def translate(text)
  if TRANSLATIONS.key?(text)
    TRANSLATIONS[text]
  else
    text
  end
end
