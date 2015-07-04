--[[--
 * 战前准备界面
 * @Author:      JuhnXu
 * @DateTime:    2015-04-30 11:51:46
 ]]
local WarReadyLayer = class("WarReadyLayer",xx.Layer)
local readyArmy = require("xx.readyArmy")

-- 位置的间隔,默认赋值为图片大小
local node_offset = nil

function WarReadyLayer:init(  )

    cc.SpriteFrameCache:getInstance():addSpriteFrames("temp.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("projectiles.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("guangqiu.plist")

    --士兵帧图
    cc.SpriteFrameCache:getInstance():addSpriteFrames("normalSoldier/jfxb.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("normalSoldier/dfxb.plist")

    --英雄
    cc.SpriteFrameCache:getInstance():addSpriteFrames("normalSoldier/lb2101.plist")

    -- 士兵特效
    cc.SpriteFrameCache:getInstance():addSpriteFrames("soldierEffects/texiao.plist")

    -- 取得士兵每个动作的数量
    xx.initSoldierFrameNum()
    xx.framesNumList.LvBu = xx.getFrameNum("lb2101")

    self.start_clicked_time = 0

    -- 保存node的列表 <key - sprite>
    -- sprite中加入tag,代表兵种类型(英雄的id)
    self.node_list = {}
    self.node_list_r = {} --敌方

    -- 保存位置的列表,与node_list根据id关联,只读<key - position>
    self.pos_list = {}

    -- 当前提起的节点的id
    self.cur_node_id = nil

    -- 提起位置org_pos
    self.org_pos = nil

    self:loadCCB()

    self:initArmyList()

    self:touch()
 
    return true
end
--[[--
 * 初始化ccb中设置的位置排布,和预设的军队列表,  
 * @param     
 * @return    
 ]]
function WarReadyLayer:initArmyList( army_l,army_r )

    -- 临时初始化方法<key - id>======================================================
        army_l = army_l or readyArmy.army_l
        self.army_l  = army_l

        army_r = army_r or readyArmy.army_r
        self.army_r = army_r

    -- 临时初始化方法 end======================================================

    -- 1.遍历pos_root子节点,把坐标保存到list中,
    for k,node in pairs(self.index.pos_root:getChildren()) do

        self.pos_list[k] = cc.p(node:getPosition())

        if nil == node_offset then
            -- 位置间隔，只初始化一次
            node_offset = node:getContentSize().width 
        end
    end

    self:updateArmyList()
end

function WarReadyLayer:updateArmyList(  )
    
    for k,v in pairs(self.node_list) do
        v:removeFromParent()
    end
    self.node_list = {}

    for k,v in pairs(self.node_list_r) do
        v:removeFromParent()
    end
    self.node_list_r = {}

    local sp = nil
    for k,v in pairs(self.army_l) do
        
        -- 读取预设的布阵列表添加到node_list
        sp = self:createHeroImg(v, 0)
         
        self.index.pos_root:addChild(sp)
        self.node_list[k] = sp
        sp:setPosition(self.pos_list[k])
        -- sprite中加入tag,代表兵种类型
        sp:setTag(v)
    end
    -- 初始化敌方
    for k,v in pairs(self.army_r) do
        
        sp = self:createHeroImg(v, 1)

        self.index.pos_root_r:addChild(sp)
        self.node_list_r[k] = sp
        sp:setPosition(self.pos_list[k])
        sp:setTag(v)
    end

end

--[[
    GB = 1,
    QQ = 2,
    ZQ = 3,
    QB = 4,   
    DB = 5,
    FS = 6,
]]
function WarReadyLayer:createHeroImg( id , num)

    local sp = nil

    if id == const.GB then
--        sp = cc.Sprite:create("actor/gong.png")
        -- dfgb1103_run_(1).png
        if num == 0 then
            sp = cc.Sprite:createWithSpriteFrameName("gb1103_run_(1).png")
        elseif num == 1 then 
            sp = cc.Sprite:createWithSpriteFrameName("dfgb1103_run_(1).png")
        end
        sp:setAnchorPoint(0.5,0)

        elseif id == const.QQ then
        if num == 0 then
            sp = cc.Sprite:createWithSpriteFrameName("qq1102_run_(1).png")
        elseif num == 1 then 
            sp = cc.Sprite:createWithSpriteFrameName("dfqq1102_run_(1).png")
        end
        sp:setAnchorPoint(0.5,0)
        
        elseif id == const.ZQ then
        if num == 0 then
            sp = cc.Sprite:createWithSpriteFrameName("zq1105_run_(1).png")
        elseif num == 1 then 
            sp = cc.Sprite:createWithSpriteFrameName("dfzq1105_run_(1).png")
        end
        sp:setAnchorPoint(0.5,0)
        
        elseif id == const.QB then
        if num == 0 then
            sp = cc.Sprite:createWithSpriteFrameName("qb1101_run_(1).png")
        elseif num == 1 then 
            sp = cc.Sprite:createWithSpriteFrameName("dfqb1101_run_(1).png")
        end
        sp:setAnchorPoint(0.5,0)
        
        elseif id == const.DB then
        if num == 0 then
            sp = cc.Sprite:createWithSpriteFrameName("db1104_run_(1).png")
        elseif num == 1 then 
            sp = cc.Sprite:createWithSpriteFrameName("dfdb1104_run_(1).png")
        end
        sp:setAnchorPoint(0.5,0)
        
        elseif id == const.FS then
        if num == 0 then
            sp = cc.Sprite:createWithSpriteFrameName("js1106_run_(1).png")
        elseif num == 1 then 
            sp = cc.Sprite:createWithSpriteFrameName("dfjs1106_run_(1).png")
        end
        sp:setAnchorPoint(0.5,0)
         
    else --未知类型
        cclog("未知类型")
        if num == 0 then
            sp = cc.Sprite:createWithSpriteFrameName("gb1103_run_(1).png")
        elseif num == 1 then 
            sp = cc.Sprite:createWithSpriteFrameName("dfgb1103_run_(1).png")
        end
        -- sp = cc.Sprite:create("actor/qi.png")
    end

    return sp
end

function WarReadyLayer:loadCCB(  )
    
    self.index = {}
    ccb.paizhen = self.index

    -- 绑定ccb的方法
    self.index.onStartWar =  xx.handler(self,self.onStartWar)
    -- self.index.onChangePosition =  WarReadyLayer.onChangePosition
    self.index.onExitBtn =  xx.handler(self,self.onExitBtn)

    self.index.onAdd = xx.handler(self,self.onAdd)
    self.index.onSub = xx.handler(self,self.onSub)

    self.index.node = CCBReaderLoad("ccb/paizhenjiemian.ccbi",cc.CCBProxy:create(),self.index)
    local size = self.index.node:getContentSize()
    cclog("size = " .. size.width .." h = " .. size.height)
    -- self.index.node:setAnchorPoint(cc.p(0.5,0.5))

    self.index.node:setPosition(xx.visible_w / 2 - 480,0)
    self:addChild(self.index.node)
end

function WarReadyLayer:onExitBtn(  )
    cclog(" WarReadyLayer.onExitBtn")
end

function WarReadyLayer:onStartWar( sender,controlEvent )

			-- Touch Up Inside.按着的时候弹起
	    if controlEvent == cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE then
        
            if self.start_clicked_time == 0 then
                self.start_clicked_time = self.start_clicked_time + 1
            else
                return
            end	        
			xx.Scene:popLayer()	

            -- 更新最终阵型列表,以后考虑要保存到游戏数据中
            -- self.army_l = {}
            -- self.army_r = {}
            -- for k,v in pairs(self.node_list) do
            --     self.army_l[k] = v:getTag()
            -- end

            -- for k,v in pairs(self.node_list_r) do
            --     self.army_r[k] = v:getTag()
            -- end

         --    local layer = require("View.WarLayer"):create(self.army_l,self.army_r)
	        -- xx.Scene:pushLayer(layer)

            --test
            xx.Scene:pushLayer(require("test.FormatLayer"):create())
	    end
end
 
function WarReadyLayer:touch()
    
    -- 触摸开始
    -- 2.鼠标点击的时候模糊匹配每个坐标,匹配成功直接break,失败返回false
    local function onTouchBegan(touch, event)

        local pos = touch:getLocation() -- 获取触点的位置
        pos = self.index.pos_root:convertToNodeSpace(pos)

        for k,p in pairs(self.pos_list) do

            if cc.pFuzzyEqual(pos,p,node_offset) then
            -- 3.成功的话检测对应的位置有没有兵的图片,有的话提起来,保存当前图片的指针cur_node,保存提起位置org_pos
                if self.node_list[k] then
                    
                    self.org_pos = p
                    self.cur_node_id = k

                    break
                end 

            end 

        end

        return true  -- 必须返回true 后边move end才会被处理                   
    end
     
    -- 触摸移动
    local function onTouchMoved(touch, event)

        -- 4.如果flag提起的话,move函数更新cur_node的位置
        if not self.cur_node_id then
            return
        end
        local pos = touch:getLocation() -- 获取触点的位置
        pos = self.index.pos_root:convertToNodeSpace(pos)
        self.node_list[self.cur_node_id]:setPosition(pos)
    end
    
    -- 触摸结束
    local function onTouchEnded(touch, event)
        
        -- print("Touch Ended")
        if not self.cur_node_id then
            return
        end

        local pos = touch:getLocation() -- 获取触点的位置
        pos = self.index.pos_root:convertToNodeSpace(pos)

        -- 是否找到合适的位置
        local is_found = false

        -- 5.松开的时候,遍历list,看是否能模糊匹配上,匹配上的话就放到该位置,否则放回原来提起的位置,更新node_list的位置
        for k,p in pairs(self.pos_list) do

            if cc.pFuzzyEqual(pos,p,node_offset) then

                self.node_list[self.cur_node_id]:setPosition(self.pos_list[k])

                if not self.node_list[k] then --前提当前位置没有兵
                    
                    self.node_list[k] = self.node_list[self.cur_node_id] 
                    self.node_list[self.cur_node_id] = nil

                else --有兵的话交换位置

                    self.node_list[k]:setPosition(self.pos_list[self.cur_node_id])
                    self.node_list[k],self.node_list[self.cur_node_id] = self.node_list[self.cur_node_id] ,self.node_list[k]
                end 
                is_found = true
                -- 找到了对应位置跳出for循环
                break

            end 

        end

        -- 找不到放回原位
        if not is_found then
            self.node_list[self.cur_node_id]:setPosition(self.org_pos)
        end
        -- 松开都要清空当前点
        self.org_pos = nil
        self.cur_node_id = nil

    end
     
    -- 注册单点触摸
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()
     
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
     
    dispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end


-- local function onCCControlButtonClicked(sender,controlEvent)
--     local labelTTF = TestButtonsLayer["mCCControlEventLabel"]

--     if nil == labelTTF then
--         return
--     end
    
--     if controlEvent == cc.CONTROL_EVENTTYPE_TOUCH_DOWN  then      
--         labelTTF:setString("Touch Down.")        
--     elseif controlEvent == cc.CONTROL_EVENTTYPE_DRAG_INSIDE then
--         labelTTF:setString("Touch Drag Inside.") 
--     elseif controlEvent == cc.CONTROL_EVENTTYPE_DRAG_OUTSIDE then
--         labelTTF:setString("Touch Drag Outside.") 
--     elseif controlEvent == cc.CONTROL_EVENTTYPE_DRAG_ENTER then
--         labelTTF:setString("Touch Drag Enter.") 
--     elseif controlEvent == cc.CONTROL_EVENTTYPE_DRAG_EXIT then
--         labelTTF:setString("Touch Drag Exit.") 
--     elseif controlEvent == cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE then
--         labelTTF:setString("Touch Up Inside.") 
--     elseif controlEvent == cc.CONTROL_EVENTTYPE_TOUCH_UP_OUTSIDE then
--         labelTTF:setString("Touch Up Outside.") 
--     elseif controlEvent == cc.CONTROL_EVENTTYPE_TOUCH_CANCEL then
--         labelTTF:setString("Touch Cancel.") 
--     elseif controlEvent == cc.CONTROL_EVENT_VALUECHANGED  then
--         labelTTF:setString("Value Changed.") 
--     end
-- end

function WarReadyLayer:onAdd( sender,controlEvent )
    
    if controlEvent == cc.CONTROL_EVENTTYPE_TOUCH_DOWN  then    
        cclog("onAdd")
        -- jx
            -- [10] = const.QI, 
            self.army_l[#self.army_l + 1] =  math.random(1,3)
            self:updateArmyList()
    end  
end

function WarReadyLayer:onSub( sender,controlEvent )
        
    if controlEvent == cc.CONTROL_EVENTTYPE_TOUCH_DOWN  then  
        cclog("onSub")
            self.army_l[#self.army_l] =  nil
            self:updateArmyList()
    end  
end
return WarReadyLayer