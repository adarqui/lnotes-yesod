{-# LANGUAGE ExplicitForAll  #-}
{-# LANGUAGE KindSignatures  #-}
{-# LANGUAGE RecordWildCards #-}

module LN.Cache.Internal (
  module A,
  cacheRun,
  cacheRun',
  modifyCache,
  getsCache,
  getUserC,
  putUserC,
  getOrganizationC,
  putOrganizationC,
  getTeamC,
  putTeamC,
  getForumC,
  putForumC,
  getBoardC,
  putBoardC,
  getThreadC,
  putThreadC,
  getThreadPostC,
  putThreadPostC,
) where



import           Control.Monad.Trans.RWS
import qualified Data.Map                as Map
import           Haskell.Helpers.Either  as A

import           LN.Cache   as A
import           LN.Control
import           LN.Import



cacheRun
  :: Maybe (CacheEntry a)
  -> HandlerErrorEff a         -- ^ CacheMissing        - an entry was previously looked up, but not found
  -> (a -> HandlerErrorEff a)  -- ^ CacheEntry (Just a) - an entry exists
  -> HandlerErrorEff a         -- ^ CacheEntry Nothing  - an entry doesnt exist and was never looked up
  -> HandlerErrorEff a

cacheRun m_c_entry go_missing go_entry go_nothing =
  case m_c_entry of
    Just CacheMissing   -> go_missing
    Just (CacheEntry a) -> go_entry a
    Nothing             -> go_nothing



cacheRun'
  :: Maybe (CacheEntry a)
  -> HandlerErrorEff a         -- ^ CacheEntry Nothing  - an entry doesnt exist and was never looked up
  -> HandlerErrorEff a

cacheRun' m_c_entry go_nothing = cacheRun m_c_entry (leftA Error_NotFound) rightA go_nothing



modifyCache
  :: forall r w (m :: * -> *). (Monad m, Monoid w)
  => (Cache -> Cache)
  -> RWST r w InternalControlState m ()

modifyCache go = do
  modify (\st@InternalControlState{..} -> st{ cache = go cache })



getsCache
  :: forall b r w (m :: * -> *). (Monad m, Monoid w)
  => (Cache -> b)
  -> RWST r w InternalControlState m b

getsCache field = do
  field <$> gets cache



getUserC :: UserId -> HandlerEff (Maybe (CacheEntry (Entity User)))
getUserC user_id = do
  c_users <- getsCache cacheUsers
  let
    m_c_user = Map.lookup user_id c_users
  case m_c_user of
    Nothing     -> pure Nothing
    Just c_user -> pure $ Just c_user



putUserC :: UserId -> CacheEntry (Entity User) -> HandlerErrorEff ()
putUserC user_id c_user = do
  modifyCache (\st@Cache{..}->st{ cacheUsers = Map.insert user_id c_user cacheUsers })
  rightA ()



getOrganizationC :: OrganizationId -> HandlerEff (Maybe (CacheEntry (Entity Organization)))
getOrganizationC user_id = do
  c_users <- getsCache cacheOrganizations
  let
    m_c_user = Map.lookup user_id c_users
  case m_c_user of
    Nothing     -> pure Nothing
    Just c_user -> pure $ Just c_user



putOrganizationC :: OrganizationId -> CacheEntry (Entity Organization) -> HandlerErrorEff ()
putOrganizationC user_id c_user = do
  modifyCache (\st@Cache{..}->st{ cacheOrganizations = Map.insert user_id c_user cacheOrganizations })
  rightA ()



getTeamC :: TeamId -> HandlerEff (Maybe (CacheEntry (Entity Team)))
getTeamC user_id = do
  c_users <- getsCache cacheTeams
  let
    m_c_user = Map.lookup user_id c_users
  case m_c_user of
    Nothing     -> pure Nothing
    Just c_user -> pure $ Just c_user



putTeamC :: TeamId -> CacheEntry (Entity Team) -> HandlerErrorEff ()
putTeamC user_id c_user = do
  modifyCache (\st@Cache{..}->st{ cacheTeams = Map.insert user_id c_user cacheTeams })
  rightA ()



getForumC :: ForumId -> HandlerEff (Maybe (CacheEntry (Entity Forum)))
getForumC user_id = do
  c_users <- getsCache cacheForums
  let
    m_c_user = Map.lookup user_id c_users
  case m_c_user of
    Nothing     -> pure Nothing
    Just c_user -> pure $ Just c_user



putForumC :: ForumId -> CacheEntry (Entity Forum) -> HandlerErrorEff ()
putForumC user_id c_user = do
  modifyCache (\st@Cache{..}->st{ cacheForums = Map.insert user_id c_user cacheForums })
  rightA ()



getBoardC :: BoardId -> HandlerEff (Maybe (CacheEntry (Entity Board)))
getBoardC user_id = do
  c_users <- getsCache cacheBoards
  let
    m_c_user = Map.lookup user_id c_users
  case m_c_user of
    Nothing     -> pure Nothing
    Just c_user -> pure $ Just c_user



putBoardC :: BoardId -> CacheEntry (Entity Board) -> HandlerErrorEff ()
putBoardC user_id c_user = do
  modifyCache (\st@Cache{..}->st{ cacheBoards = Map.insert user_id c_user cacheBoards })
  rightA ()



getThreadC :: ThreadId -> HandlerEff (Maybe (CacheEntry (Entity Thread)))
getThreadC user_id = do
  c_users <- getsCache cacheThreads
  let
    m_c_user = Map.lookup user_id c_users
  case m_c_user of
    Nothing     -> pure Nothing
    Just c_user -> pure $ Just c_user



putThreadC :: ThreadId -> CacheEntry (Entity Thread) -> HandlerErrorEff ()
putThreadC user_id c_user = do
  modifyCache (\st@Cache{..}->st{ cacheThreads = Map.insert user_id c_user cacheThreads })
  rightA ()



getThreadPostC :: ThreadPostId -> HandlerEff (Maybe (CacheEntry (Entity ThreadPost)))
getThreadPostC user_id = do
  c_users <- getsCache cacheThreadPosts
  let
    m_c_user = Map.lookup user_id c_users
  case m_c_user of
    Nothing     -> pure Nothing
    Just c_user -> pure $ Just c_user



putThreadPostC :: ThreadPostId -> CacheEntry (Entity ThreadPost) -> HandlerErrorEff ()
putThreadPostC user_id c_user = do
  modifyCache (\st@Cache{..}->st{ cacheThreadPosts = Map.insert user_id c_user cacheThreadPosts })
  rightA ()
