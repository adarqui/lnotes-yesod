{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE TypeOperators  #-}

module LN.Error (
  notFoundMaybe,
  errorOrJSON,
  permissionDeniedEither,
) where



import           Data.Aeson (encode)
import           LN.Import
import           LN.Misc    (cs)
import           LN.T.Error (ApplicationError)



notFoundMaybe :: forall (m :: * -> *) a. MonadHandler m => Maybe a -> m a
notFoundMaybe mentity = do
  case mentity of
    Nothing       -> notFound
    (Just entity) -> pure entity



errorOrJSON :: (MonadHandler m, ToJSON b) => (a -> b) -> m (Either ApplicationError a) -> m Value
errorOrJSON trfm go = do
  e <- (fmap (toJSON . trfm)) <$> go
  case e of
    Left err -> do
      addHeader "X-JSON-ERROR" (cs $ encode err)
      permissionDenied $ cs $ encode err
    Right v  -> pure v



permissionDeniedEither :: forall (m :: * -> *) b. MonadHandler m => Either Text b -> m b
permissionDeniedEither lr = do
  case lr of
    Left err -> permissionDenied err
    Right b  -> pure b
