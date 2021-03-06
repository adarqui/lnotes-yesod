module LN.Model where



import           ClassyPrelude.Yesod
import           Database.Persist.Quasi
import           LN.Model.DerivePersist



-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share
  [
    mkPersist sqlSettings,
    mkDeleteCascade sqlSettings,
    mkSave "entityDefs"
  ]
  $(persistFileWith lowerCaseSettings "config/models")
